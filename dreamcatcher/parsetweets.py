import nounphrases

import nltk
import sys
wordsToRemove = ['dream', 'last', 'night']

def removeDupes(list):
    newList = []
    existingIDs = []
    for tweet in list:
        if tweet.id_str in existingIDs:
            continue
        newList.append(tweet)
        existingIDs.append(tweet.id_str)
    return newList
def ignoreRTs(tweet):
    if hasattr(tweet, 'retweeted_status'):
        tweet = tweet.retweeted_status
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

def filterWordsFromPhrases(term):
    filteredTerm = ""
    numWords = 0
    for word in term:
        if not word in wordsToRemove:
            numWords += 1
            filteredTerm += word + ' '
    return {"text": filteredTerm.strip(), "numWords": numWords}
def filterWordsFromText(text):
    text = text.lower()
    for word in wordsToRemove:
        inTextPos = text.find(word)
        if inTextPos != -1:
            text = text[0:inTextPos] + text[inTextPos + len(word) : ]

    return text
def parseTweets(list):
    for tweet in list:
        #search for nouns in tweet
        tweetPhrases = nounphrases.getNouns(tweet.textNoEntities)
        #remove certain words
        tweet.nouns = [filterWordsFromPhrases(phrase) for  phrase in tweetPhrases]
        #some nouns might be empty now, remove them
        removeEmpty = []
        for noun in tweet.nouns:
            if noun['numWords'] > 0:
                removeEmpty.append(noun)
        tweet.nouns = removeEmpty
        