#!/usr/bin/env python
from tornado.escape import json_decode, json_encode
from tornado.ioloop import IOLoop
from tornado.options import define, options, parse_command_line, parse_config_file
import tornado.web
import logging
define('port', default=8888, help="port to listen on")

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('index.html')


def main():
    parse_command_line(final=False)

    app = tornado.web.Application(
        [
            ('/', MainHandler),
            ("/static/(.*)", tornado.web.StaticFileHandler, {"path": "static"}),

        ]
    )
    app.listen(options.port)
    IOLoop.instance().start()

if __name__ == '__main__':
    main()