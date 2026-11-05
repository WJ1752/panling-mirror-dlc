#!/usr/bin/env python3
"""Minimal Source RCON client - deploy/verification helper (kept outside the server dir).

Vanilla sends command output as one or more packets and no explicit terminator, so the end of
a response is detected by an idle timeout (first packet may take much longer than later ones).
"""
import socket, struct, sys, time

IDLE = 0.6  # seconds of silence = end of response


def pack(rid, ptype, payload):
    body = struct.pack('<ii', rid, ptype) + payload.encode('utf-8') + b'\x00\x00'
    return struct.pack('<i', len(body)) + body


def recv_packet(sock):
    hdr = b''
    while len(hdr) < 4:
        chunk = sock.recv(4 - len(hdr))
        if not chunk:
            raise ConnectionError('socket closed')
        hdr += chunk
    (length,) = struct.unpack('<i', hdr)
    body = b''
    while len(body) < length:
        chunk = sock.recv(length - len(body))
        if not chunk:
            raise ConnectionError('socket closed')
        body += chunk
    rid, ptype = struct.unpack('<ii', body[:8])
    return rid, ptype, body[8:-2].decode('utf-8', 'replace')


def connect(host, port, password, timeout=10):
    s = socket.create_connection((host, port), timeout=timeout)
    s.sendall(pack(0, 3, password))
    s.settimeout(timeout)
    for _ in range(3):
        try:
            rid, ptype, _ = recv_packet(s)
        except (socket.timeout, TimeoutError):
            raise PermissionError('rcon auth timeout')
        if rid == -1 and ptype == 2:
            raise PermissionError('rcon auth failed (bad password)')
        if ptype == 2 and rid == 0:
            return s
    raise PermissionError('rcon auth: unexpected responses')


def command(sock, cmd, timeout=600):
    sock.sendall(pack(1, 2, cmd))
    out = []
    sock.settimeout(timeout)          # first packet may take a long time
    while True:
        try:
            rid, ptype, payload = recv_packet(sock)
        except (socket.timeout, TimeoutError, ConnectionError):
            break
        if rid == -1:
            continue
        out.append(payload)
        sock.settimeout(IDLE)         # afterwards: idle = done
    return '\n'.join(x for x in out if x).strip()


if __name__ == '__main__':
    port = int(sys.argv[1])
    pw = open(sys.argv[2]).read().strip()
    cmds = sys.argv[3:]
    s = None
    for attempt in range(20):
        try:
            s = connect('127.0.0.1', port, pw)
            break
        except Exception as e:
            if attempt == 19:
                print('CONNECT FAILED:', e)
                sys.exit(1)
            time.sleep(2)
    for c in cmds:
        print('>>> ' + c)
        print(command(s, c))
