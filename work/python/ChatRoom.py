#!/usr/bin/env python3
# coding=utf-8
# *************************************************
# File Name    : ChatRoom.py
# Author       : Cole Smith
# Mail         : tobewhatwewant@gmail.com
# Github       : whatwewant
# Created Time : 2015年09月20日 星期日 16时23分00秒
# *************************************************

import socket
import sys
from queue import Queue
from _thread import *
import select

class RoomServer:
    def __init__(self):
        self.HOST = ''
        self.PORT = 5555
        self.MAX_CLIENT = 5
        # self.conn_queue = Queue()
        self.conn_poll = list()
        
        self.server_up()

    def server_up(self):
        self._create_socket()
        self._bind()
        self._listen()
        print('Waiting Somebody to come in ...')
        self._waiting()
        self._exit()

    def _create_socket(self):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        # self.socket.setblocking(0)

        self.conn_poll.append(self.socket)
    
    def _bind(self):
        try:
            self.socket.bind((self.HOST, self.PORT))
        except socket.error as e:
            print(str(e))
            sys.exit(-1)

    def _listen(self):
        self.socket.listen(self.MAX_CLIENT)

    def _threaded_client(self, conn, addr):
        conn.send(str.encode('Welcome to this ChatRoom\n'))

        try:
            while True:
                data = conn.recv(2048)
                if not data:
                    self.broadcast(message='Client {0}:{1} out.'.format(addr[0], addr[1]))
                    break
                self.broadcast(conn, 'Client {0}:{1} : {2}\n'.format(
                        addr[0], addr[1], data.decode('utf-8')
                    ))
                reply = 'Server: Your message has been broadcast.\n'
                conn.sendall(str.encode(reply))
        except :
            pass
        finally:
            self.conn_poll.remove((conn, addr))
            conn.close()

    def _waiting(self):
        while True:
            read_sockets, write_sockets, error_sockets = select.select(
                    self.conn_poll, [], [])
            for sock in read_sockets:
                # new connection
                if sock == self.socket:
                    conn, addr = self.socket.accept()
                    conn.sendall(str.encode('Current Room Users: %s\n' % (len(self.conn_poll))))
                    self.conn_poll.append(conn)
                    print('Client %s:%s in' % addr)
                    self.broadcast(conn, "[%s:%s] enter\n" % addr)
                # some incoming message from a client
                else:
                    try:
                        data = sock.recv(1024)
                        if data:
                            self.broadcast(sock, 
                                    "\r" + '<' + str(sock.getpeername()) + '> ' + data.decode('utf-8') + '\n')
                    except :
                        self.broadcast(sock, 'Client (%s, %s) is offline.\n' % addr)
                        print('client (%s, %s) is offline' % addr)
                        sock.close()
                        self.conn_poll.remove(sock)
                        continue

    def _exit(self):
        print('Server Exit')
        self.socket.close()
    
    def _encrypt(self, data):
        return data

    def _decrypt(self, data):
        return data
    
    def broadcast(self, conn, message):
        '''
            conn : current client connect
            message: the message from current conn
        '''
        for o_conn in self.conn_poll:
            if o_conn != self.socket and o_conn != conn:
                try:
                    o_conn.send(str.encode(message))
                except:
                    conn.close()
                    self.conn_poll.remove(conn)


if __name__ == '__main__':
    RoomServer()
