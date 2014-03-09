import nltk
import nounphrases

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

def filterWords(term):
    filteredTerm = []
    for word in term:
        if not word in wordsToRemove:
            filteredTerm.append(word)
    return filteredTerm
def parseTweets(list):
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
