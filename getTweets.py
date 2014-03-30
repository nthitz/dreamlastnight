#actually get the tweets and save em and what not  
import tweepyutils
import pgutils
import parsetweets
import requests
import json
#import spellcheck


pgCursor = pgutils.getCursor()
list = None
tweetTypes = None
def log(string):
    print string

def init():
    global list
    list = tweepyutils.search(q='dream last night', result_type='popular', count=100) + tweepyutils.search(q='dream last night', count=100)
    #list = tweepyutils.search(q='dream last night',result_type='popular', count=10)
    #list = tweepyutils.search(q='dream last night filter:images',result_type='popular', count=10)
    list.sort(key=lambda x: x.favorite_count + x.retweet_count, reverse=True)
    
    print(dir(list[0]))
    #label retweets as null
    list = [parsetweets.ignoreRTs(tweet) for tweet in list]

    #remove null entries
    list = [item for item in list if item != None]

    #remove dupes
    list = parsetweets.removeDupes(list)

    #remove the twitter entities, search for those without nltk    
    list = [parsetweets.removeEntities(tweet) for tweet in list]
    parsetweets.parseTweets(list)
    searchAndInsertTweets(len(list))

    pgutils.close()
def searchAndInsertTweets(count):
    global tweetTypes
    tweetTypes = pgutils.getRelationByValues('term_type','type')
    for i in range(count):
        tweet = list[i]
        insert = searchTweetImages(tweet)
        if insert:
            insertTweet(tweet)
def searchTweetImages(tweet):
    exists = pgutils.getQueryDictionary('SELECT COUNT(*) as exists FROM tweet WHERE twitter_id=%s', tweet.id_str)
    if exists[0]['exists'] != 0:
        return False
    tweet.termIDs = []
    tweet.screenNames = []
    for type in tweetTypes:
        typeObj = tweetTypes[type]
        success = tweepyutils.fetchImages(typeObj, tweet)
        if not success:
            return False
    return True
    #this all gonna be done in tweepyutils.fetchImages
    #entities
    # media, user_mentions, hashtags. 
      #media can be grabbed directly
    #user_mentions we just want profile pic
    #hashtags we have to search

    
    #noun phrases

    #original username  
def insertTweet(tweet):
    twitterID = tweet.id_str
    time = tweet.created_at

    #oembed endpoint https://dev.twitter.com/docs/api/1/get/statuses/oembed v1 endpoint
    oembedParams = {'id': twitterID, 'omit_script': 'true'}
    oembedRequest = requests.get('https://api.twitter.com/1/statuses/oembed.json', params=oembedParams)
    embedResponse = json.loads(oembedRequest.text)
    embed_html = embedResponse['html']

    processed = True
    display = True
    num_images = len(tweet.termIDs)

    q = 'INSERT INTO tweet (twitter_id, time, embed_html, processed, display, num_images) VALUES ( %s, %s, %s, %s, %s, %s ) RETURNING tweet_id'
    tweetID = pgutils.getQueryDictionary(q, twitterID, time, embed_html, processed, display, num_images)
    tweetID = tweetID[0]['tweet_id']
    
    #insert terms
    if len(tweet.termIDs) > 0:
        termIDsStr = ','.join(pgCursor.mogrify("(%s,%s)", (tweetID, termID)) for termID in tweet.termIDs)
        q = 'INSERT INTO tweet_has_term (tweet_id, term_id) VALUES ' + termIDsStr
        pgCursor.execute(q)

    #insert users
    if len(tweet.screenNames) > 0:
        twitterUsersStr = ','.join(pgCursor.mogrify("(%s, %s, %s)", [twitterUser['screen_name'], tweetID, twitterUser['relationship']]) for twitterUser in tweet.screenNames)
        q = 'INSERT INTO tweet_has_user (screen_name, tweet_id, relationship) VALUES ' + twitterUsersStr
        pgCursor.execute(q)

    
init()
#for tag in tags:
#   if tag[1][0] == "N":
#       nouns.append(tag)
#print nouns
# nltk.help.upenn_tagset()
# http://www.nltk.org/book/ch07.html 7.2 Chunking 
# https://gist.github.com/alexbowe/879414
# http://en.wikipedia.org/wiki/Noun_phrase
# http://en.wikipedia.org/wiki/English_grammar#Noun_phrases
