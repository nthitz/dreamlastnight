import os

import tweepy
import nltk
import nounphrases
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
list = api.search(q='dream last night', result_type='popular', count=100) + api.search(q='dream last night', count=100)
#list = api.search(q='dream last night', count=20)

list.sort(key=lambda x: x.favorite_count + x.retweet_count, reverse=True)
print(dir(list[0]))

wordsToRemove = ['dream', 'last', 'night']
def filterWords(term):
    filteredTerm = []
    for word in term:
        if not word in wordsToRemove:
            filteredTerm.append(word)
    return filteredTerm
for tweet in list:
    #print tweet.user.screen_name + ": " + tweet.text 
    #print "{} {}".format(tweet.favorite_count,tweet.retweet_count)

    tokens = nltk.word_tokenize(tweet.text)
    tags = nltk.pos_tag(tokens)
    nouns = []
    tweetPhrases = nounphrases.getNouns(tweet.text)
    tweetPhrases = [filterWords(phrase) for  phrase in tweetPhrases]
    #tweetPhrases = map(filterWords, tweetPhrases)

    for term in tweetPhrases:
        if len(term) is 0:
            continue;
        for word in term:
            print word,
        print ", ",
    print

#for tag in tags:
#   if tag[1][0] == "N":
#       nouns.append(tag)
#print nouns
# nltk.help.upenn_tagset()
# http://www.nltk.org/book/ch07.html 7.2 Chunking 
# https://gist.github.com/alexbowe/879414
# http://en.wikipedia.org/wiki/Noun_phrase
# http://en.wikipedia.org/wiki/English_grammar#Noun_phrases
