#actually get the tweets and save em and what not  
import tweepyutils
import pgutils
import parsetweets
#import spellcheck


pgCursor = pgutils.getCursor()
list = None
tweetTypes = None
def log(string):
    print string

def init():
    global list
    #list = tweepyutils.search(q='dream last night', result_type='popular', count=100) + tweepyutils.search(q='dream last night', count=100)
    #list = tweepyutils.search(q='dream last night',result_type='popular', count=10)
    list = tweepyutils.search(q='dream last night filter:images',result_type='popular', count=10)
    list.sort(key=lambda x: x.favorite_count , reverse=True)
    
    #print(dir(list[0]))
    #label retweets as null
    list = [parsetweets.ignoreRTs(tweet) for tweet in list]

    #remove null entries
    list = [item for item in list if item != None]

    #remove dupes
    list = parsetweets.removeDupes(list)

    #remove the twitter entities, search for those without nltk    
    list = [parsetweets.removeEntities(tweet) for tweet in list]
    parsetweets.parseTweets(list)
    searchAndInsertTweets(1)

    pgutils.close()
def searchAndInsertTweets(count):
    global tweetTypes
    tweetTypes = pgutils.getRelationByValues('term_type','type')
    print tweetTypes
    for i in range(count):
        tweet = list[i]
        searchTweetImages(tweet)
        insertTweet(tweet)
def searchTweetImages(tweet):
    tweet.termIDs = []
    for type in tweetTypes:
        typeObj = tweetTypes[type]
        tweepyutils.fetchImages(typeObj, tweet)
    
    print "WE WILL NEED SOMETHING HERE TO INSERT termIDs and tweet id"
    
    #this all gonna be done in tweepyutils.fetchImages
    #entities
    # media, user_mentions, hashtags. 
      #media can be grabbed directly
    #user_mentions we just want profile pic
    #hashtags we have to search

    print tweet.entities

    #noun phrases

    #original username  
    pass
def insertTweet(tweet):
    pass

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
