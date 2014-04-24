#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright 2013 Cédric Picard
#
# LICENSE
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
# END_OF_LICENSE
#


"""
Quickly share files using a simple http server.

Usage: qs [-p PORT] [-r RATE] [DIRECTORY]

Options:
    -h, --help          Print this help and exit.
    -p, --port PORT     Port on which the server is listenning.
                        Default is 8000
    -r, --rate RATE     Limit upload to RATE in ko/s.
                        Default is 0 meaning no limitation.

Arguments:
    DIRECTORY           Directory to share.
                        Default is `.'
"""


import SimpleHTTPServer
import SocketServer
from os        import chdir
from time      import time, sleep
from docopt    import docopt
from threading import Lock


class TokenBucket:
    """
    An implementation of the token bucket algorithm. See also :
    http://code.activestate.com/recipes/578659-python-3-token-bucket-rate-limit/
    """
    def __init__(self):
        self.tokens = 0
        self.rate = 0
        self.last = time()
        self.lock = Lock()

    def set_rate(self, rate):
        with self.lock:
            self.rate = rate
            self.tokens = self.rate

    def consume(self, tokens):
        with self.lock:
            if not self.rate:
                return 0

            now = time()
            lapse = now - self.last
            self.last = now
            self.tokens += lapse * self.rate

            if self.tokens > self.rate:
                self.tokens = self.rate

            self.tokens -= tokens

            if self.tokens >= 0:
                return 0
            else:
                return -self.tokens / self.rate


class HTTPRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    """
    SimpleHTTPRequestHandler with overiden methods to include rate limit.
    """

    def __init__(self, request, client_address, server, rate):
        self.rate           = rate * 1024
        self.bucket         = TokenBucket()
        self.bucket.set_rate(self.rate)
        SocketServer.BaseRequestHandler.__init__(self, request,
                                                 client_address, server)

    def copyfile(self, source, outputfile):
        self.copyfileobj(source, outputfile)

    def copyfileobj(self, fsrc, fdst, length=16*1024):
        """
        copy data from file-like object fsrc to file-like object fdst
        overidden to include token bucket rate limiting
        """
        while 1:
            if self.rate != 0:
                sleep(self.bucket.consume(length))
            buf = fsrc.read(length)
            if not buf:
                break
            fdst.write(buf)


class _TCPServer(SocketServer.TCPServer):
    def __init__(self, server_address, RequestHandlerClass, rate,
                 bind_and_activate=True):
        self.rate = rate;
        SocketServer.TCPServer.__init__(self,
                                        server_address,
                                        RequestHandlerClass,
                                        bind_and_activate)

    def finish_request(self, request, client_address):
        self.RequestHandlerClass(request, client_address, self, self.rate)


def share(directory, port, rate):
    chdir(directory)

    Handler = HTTPRequestHandler
    try:
        httpd = _TCPServer(("", port), Handler, rate)
    except SocketServer.socket.error:
        print("Address already in use")
        print("Trying on port " + str(port + 1))
        share(directory, port + 1, rate)
    else:
        print "Serving at port " + str(port)
        httpd.serve_forever()


def main():
    args = docopt(__doc__)
    share_dir = args['DIRECTORY'] or '.'
    port      = args['--port']    or 8000
    rate      = args['--rate']    or 0

    port = int(port)
    rate = int(rate)

    share(share_dir, port, rate)

if __name__ == "__main__":
    main()
