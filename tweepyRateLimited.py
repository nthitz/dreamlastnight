import tweepy
import os

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