 #!/usr/bin/python
 # -*- coding: utf-8 -*-

#ensures hardcoded rate limits for tweepy

import tweepy
import os
import pgutils
from datetime import date, datetime, time, timedelta

# The consumer keys can be found on your application's Details
# page located at https://dev.twitter.com/apps (under "OAuth settings")
consumer_key=os.environ["TwitterConsumerKey"]
consumer_secret=os.environ["TwitterConsumerSecret"]

# The access tokens can be found on your applications's Details
# page located at https://dev.twitter.com/apps (located 
# under "Your access token")
access_token=os.environ["TwitterAccessToken"]
access_token_secret=os.environ["TwitterAccessTokenSecret"]

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

pgCursor = pgutils.getCursor()
numSearches = 0
maxSearches = 180
def search(**arg):
    global numSearches, maxSearches
    if numSearches >= maxSearches:
        print "too many searches"
        return
    numSearches += 1
    result = api.search(**arg)
    return result

#returns the ID for the requested term
#inserts it into DB if doesnt ex==t
#also flags whether or not it needs to be updated
def selectOrInsertTerm(term, term_type):
    termExists = pgutils.getQueryDictionary('SELECT * FROM term WHERE term=%s and term_type_id=%s', term, term_type['term_type_id'])
    termRtn = {}
    if len(termExists) == 0:
        termRtn['expired'] = True
        #insert
        q = 'INSERT INTO term (term, term_type_id) VALUES (%s, %s) RETURNING term_id'
        type_id = term_type['term_type_id']
        id = pgutils.getQueryDictionary(q, term, type_id)
        termRtn['id'] = id[0]['term_id']

    else:
        #check expiration
        last_queried_at = termExists[0]['last_queried_at']
        if last_queried_at == None:
            termRtn['expired'] = True
        else:
            expiredAt = datetime.now() - term_type['expires_after']
            if last_queried_at < expiredAt:
                termRtn['expired'] = True
            else:
                termRtn['expired'] = False
        termRtn['id'] = termExists[0]['term_id']
    return termRtn
def insertTwitterUserIfNotPresent(screen_name,term_type):
    userExists = pgutils.getQueryDictionary('SELECT * FROM twitter_user WHERE screen_name=%s', screen_name)
    expired = None
    if len(userExists) == 0:
        expired = True
        #insert
        q = 'INSERT INTO twitter_user (screen_name) VALUES (%s)'
        pgCursor.execute(q, [screen_name])
    else:
        #check expiration
        last_queried_at = userExists[0]['updated_at']
        if last_queried_at == None:
            expired = True
        else:
            expiredAt = datetime.now() - term_type['expires_after']
            if last_queried_at < expiredAt:
                expired = True
            else:
                expired = False
    return expired
def insertTermImages(term_id, urls, removePreviousTermImages = False):
    if removePreviousTermImages:
        pgCursor.execute('DELETE FROM image WHERE term_id=%s', [term_id])
    args = [(url, term_id) for url in urls]
    argsStr = ','.join(pgCursor.mogrify("(%s,%s,now())", x) for x in args)

    q = 'INSERT INTO image (url, term_id, retrieved_at) VALUES ' + argsStr
    pgCursor.execute(q)
    q = 'UPDATE term SET last_queried_at=now() WHERE term_id=%s'
    pgCursor.execute(q, [term_id])

def fetchMedia(type, tweet):
    
    if not 'media' in tweet.entities:
        return
    medias = tweet.entities['media']
    for media in medias:
        url = media['media_url']
        # search for url in db
        #if ex==ts 
        termID = selectOrInsertTerm(url, type)
        tweet.termIDs.append(termID['id'])
        if termID['expired']:
            #media is easy, just insert url as image
            #arguably not even needed as url is key but ¯\_(ツ)_/¯
            insertTermImages(termID['id'], [url], True)
    
def fetchUserImage(type, tweet):
    usersToSearch = []
    if type['type'] == 'dreamer':
        usersToSearch.append(tweet.user.screen_name)
    elif type['type'] == 'mentioned':
        for mention in tweet.entities['user_mentions']:
            usersToSearch.append(mention.screen_name)

    for screen_name in usersToSearch:
        expired = insertTwitterUserIfNotPresent(screen_name,  type)
        tweet.screenNames.append({'screen_name': screen_name, 'relationship': type['type']})
        if expired:
            user = api.get_user(screen_name=screen_name)
            userJson = api.lastJSON
            q = 'UPDATE twitter_user SET user_json=%s, updated_at=now() WHERE screen_name=%s'
            pgCursor.execute(q, (userJson, user.screen_name))
def fetchTwitterImageSearch(type, tweet):

    pass

def fetchImages(type, tweet):
    print 'fetch' + type['type']
    if type['type'] == 'media':
        fetchMedia(type, tweet)
    elif type['type'] == 'dreamer' or type['type'] == 'mentioned':
        fetchUserImage(type, tweet)
    elif type['type'] == 'hashtags' or type['type'] == 'nouns':
        fetchTwitterImageSearch(type, tweet)
