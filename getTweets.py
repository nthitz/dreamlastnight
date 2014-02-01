import tweepy
import os
import nltk
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
list = api.search(q='dream last night', result_type='popular', count=100)
print(list)	
list.sort(key=lambda x: x.favorite_count + x.retweet_count, reverse=True)
print(dir(list[0]))
for tweet in list:
	print tweet.user.screen_name + " " + tweet.text 
	print "{} {}".format(tweet.favorite_count,tweet.retweet_count)

	tokens = nltk.word_tokenize(tweet.text)
	tags = nltk.pos_tag(tokens)
	print tags
	# nltk.help.upenn_tagset()
