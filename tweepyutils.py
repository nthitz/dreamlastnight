#ensures hardcoded rate limits for tweepy

import tweepy
import os
import pgutils
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

numSearches = 0
maxSearches = 180
def search(**arg):
    global numSearches, maxSearches
    if numSearches >= maxSearches:
        print "too many searches"
        return
    numSearches += 1
    result = api.search(**arg)
    print result
    return result

#returns the ID for the requested term
#inserts it into DB if doesnt ex==t
#also flags whether or not it needs to be updated
def selectOrInsertTerm(term, term_type):
    print term_type
    termExists = pgutils.getQueryDictionary('SELECT * FROM term WHERE term=%s and term_type_id=%s', term, term_type['term_type_id'])
    termRtn = {}
    if len(termExists) == 0:
        termRtn['expired'] = True
        #insert
        q = 'INSERT INTO term (term, term_type_id) VALUES (%s, %s) RETURNING term_id'
        type_id = term_type['term_type_id']
        print q
        print term
        print type_id
        id = pgutils.getQueryDictionary(q, term, type_id)
        termRtn['id'] = id[0]['term_id']

    else:
        #check expiration
        termRtn['id'] = termExists[0]['term_id']
    print termRtn

def fetchMedia(type, tweet):
    print 'fetch media'

    if not 'media' in tweet.entities:
        return
    medias = tweet.entities['media']
    for media in medias:
        url = media['media_url']
        print url
        # search for url in db
        #if ex==ts 
        termID = selectOrInsertTerm(url, type)
        print media

def fetchUserImage(type, tweet):
    usersToSearch = []
    if type['type'] == 'dreamer':
        usersToSearch.append(tweet.id_str)
    elif type['type'] == 'mentioned':
        for mention in tweet.entities['user_mentions']:
            usersToSearch.append(mention.id_str)

    for id_str in usersToSearch:
        print 'search for user ' + id_str
        pass

def fetchTwitterImageSearch(type, tweet):

    pass

def fetchImages(type, tweet):
    print 'fetch'
    print type['type']
    if type['type'] == 'media':
        print 'fetchmedia'
        fetchMedia(type, tweet)
    elif type['type'] == 'dreamer' or type['type'] == 'mentioned':
        fetchUserImage(type, tweet)
    elif type['type'] == 'hashtags' or type['type'] == 'nouns':
        fetchTwitterImageSearch(type, tweet)