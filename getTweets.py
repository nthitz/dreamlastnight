import os
import tweepyRateLimited
import nltk
import nounphrases
import psycopg2
#import spellcheck


pgConnectionString = "dbname=" + os.environ['PGNAME'] + " user=" + os.environ['PGUSER'] + " password=" + os.environ['PGPASS']
pg = psycopg2.connect(pgConnectionString)

api = None
list = None
wordsToRemove = ['dream', 'last', 'night']

def log(string):
    print string

def init():
    global api, list
    #list = tweepyRateLimited.search(q='dream last night', result_type='popular', count=100) + tweepyRateLimited.search(q='dream last night', count=100)
    list = tweepyRateLimited.search(q='dream last night', count=10)
    list.sort(key=lambda x: x.favorite_count , reverse=True)
    
    print(dir(list[0]))
    print len(list)
    #label retweets as null
    #list = [ignoreRTs(tweet) for tweet in list]

    #remove null entries
    #list = [item for item in list if item != None]

    print len(list)
    #TODO: remove dupes
    list = removeDupes(list)

    print len(list)
    

    #remove the twitter entities, search for those without nltk    
    list = [removeEntities(tweet) for tweet in list]
    parseTweets()
    searchAndInsertTweets(1)
def searchAndInsertTweets(count):
    for i in range(count):
        tweet = list[i]
        searchTweetImages(tweet)
        insertTweet(tweet)
def searchTweetImages(tweet):
    print tweet
    pass
def insertTweet(tweet):
    pass
def removeDupes(list):
    newList = []
    existingIDs = []
    for tweet in list:
        if tweet.id_str in existingIDs:
            print 'existing'
            continue
        newList.append(tweet)
        existingIDs.append(tweet.id_str)
    return newList
def ignoreRTs(tweet):
    if hasattr(tweet, 'retweeted_status'):
        tweet = tweet.retweeted_status
        print 'rt ' + tweet.user.screen_name
        return None
    return tweet

def removeEntities(tweet):
    def removeEntity(tweet, entity):
        tweet.textNoEntities = tweet.textNoEntities[:entity['indices'][0]] + tweet.textNoEntities[entity['indices'][1]:]

    tweet.textNoEntities = tweet.text
    tweet.allEntities = []
    
    for entityType in tweet.entities:
        for entity in tweet.entities[entityType]:
            tweet.allEntities.append(entity)
    tweet.allEntities.sort(key=lambda x: x['indices'][0], reverse=True)

    tweet.allEntites = [removeEntity(tweet,entity) for entity in tweet.allEntities]

    return tweet

def filterWords(term):
    filteredTerm = []
    for word in term:
        if not word in wordsToRemove:
            filteredTerm.append(word)
    return filteredTerm
def parseTweets():
    numTerms = 0
    for tweet in list:
        #print tweet.user.screen_name + ": " + tweet.text 
        #print "{} {}".format(tweet.favorite_count,tweet.retweet_count)
        #print tweet.text
        #print tweet.textNoEntities

        #print tweet.entities
        tokens = nltk.word_tokenize(tweet.text)
        tags = nltk.pos_tag(tokens)
        nouns = []
        tweetPhrases = nounphrases.getNouns(tweet.text)
        tweetPhrases = [filterWords(phrase) for  phrase in tweetPhrases]
        #tweetPhrases = map(filterWords, tweetPhrases)
        """
        for term in tweetPhrases:
            if len(term) is 0:
                continue;
            for word in term:
                #fixed = spellcheck.correct(word)
                #print word + "=>" + fixed,
                print word + " " ,
            print ", ",
            numTerms+=1
        print
        """
    #print numTerms

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
