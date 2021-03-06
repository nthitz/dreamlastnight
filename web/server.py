#!/usr/bin/env python
from tornado.escape import json_decode, json_encode
from tornado.ioloop import IOLoop
from tornado.options import define, options, parse_command_line, parse_config_file
import tornado.autoreload
import tornado.web
import logging
import json
import datetime
from time import mktime

import pgutils

testImages = []
define('port', default=8888, help="port to listen on")

f = open('data/imgur_image_list.txt')
imageList = f.readlines()
for image in imageList:
    image = image.strip()
    slash = image.rfind('/')
    saveName = image[slash + 1:]
    imagePath = 'testImages/' + saveName
    testImages.append( imagePath )

print 'test images: ', len(testImages)

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('dist/index.html')

class DreamDataHandler(tornado.web.RequestHandler):
    def get(self):
        self.set_header('Content-Type','text/json')
        dreams = pgutils.getQueryDictionary('SELECT * FROM tweet ORDER BY time DESC LIMIT 30')
        for dream in dreams:
            q = 'SELECT term.* FROM term, tweet, tweet_has_term WHERE tweet_has_term.tweet_id = tweet.tweet_id AND tweet_has_term.term_id = term.term_id AND tweet.tweet_id=%s'
            terms = pgutils.getQueryDictionary(q, dream['tweet_id'])
            termObjs = []
            for term in terms:
                q = 'SELECT url FROM image WHERE term_id=%s'
                termImages = pgutils.getQueryDictionary(q, term['term_id'])
                termObjs.append( {"term": term, "images": termImages})
            dream['terms'] = termObjs
            q = 'SELECT tweet_has_user.*, twitter_user.user_json  FROM  tweet_has_user, twitter_user WHERE tweet_id=%s AND tweet_has_user.screen_name=twitter_user.screen_name'
            dreamPeople = pgutils.getQueryDictionary(q, dream['tweet_id'])
            userProperties = [
                'profile_use_background_image', 'default_profile_image', 'profile_background_image_url_https',
                'profile_text_color','profile_background_color','description',
                'profile_image_url_https'
            ]
            people = []
            for person in dreamPeople:
                p = {
                    "screen_name": person['screen_name'],
                    "relationship": person['relationship']
                }
                for prop in userProperties:
                    p[prop] = person['user_json'][prop]
                people.append( p )
            dream['people'] = people

        # convert python datetime to json 
        class DateTimeJSONEncoder(json.JSONEncoder):
            def default(self, obj):
                if isinstance(obj, datetime.datetime):
                    return int(mktime(obj.timetuple()))
                return json.JSONEncoder.default(self, obj)
        rtnJson = dreams
        self.write(json.dumps(rtnJson, cls = DateTimeJSONEncoder))

class TestDataHandler(tornado.web.RequestHandler):
    def get(self):
        self.set_header('Content-Type','text/json')
        rtnJson = testImages
        self.write(json.dumps(rtnJson))
def main():
    parse_command_line(final=False)

    appConfig = [
            ('/', MainHandler),
            ('/dreamdata', DreamDataHandler),
            ('/testdata', TestDataHandler),
            ("/js/(.*)", tornado.web.StaticFileHandler, {"path": "web/dist/js/"}),
            ("/css/(.*)", tornado.web.StaticFileHandler, {"path": "web/dist/css/"}),
            ("/testImages/(.*)", tornado.web.StaticFileHandler, {"path": "testImages/"})
       ]
 
    app = tornado.web.Application(appConfig)
    app.listen(options.port)
    def reloadHook():
        print 'reloading'
    tornado.autoreload.watch('web/dist/index.html')
    tornado.autoreload.add_reload_hook(reloadHook)
    tornado.autoreload.start()
    IOLoop.instance().start()

if __name__ == '__main__':
    main()