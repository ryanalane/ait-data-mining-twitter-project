require 'mongo'

# Sets up connection to Mongo database
db = Mongo::Connection.new.db("ait_twitter_mining")

geotagged_tweets = db.collection("geotagged")
dc_tweets = db.collection("dc_tweets")
houston_tweets = db.collection("houston_tweets")

DC_latitude_bounds = {'lower' => 38.582526, 'higher' => 39.253084}
Houston_latitude_bounds = {'lower' => 29.4862, 'higher' => 30.4538}

dc_tweet_count = 0
houston_tweet_count = 0

geotagged_tweets.find.each do |tweet|
  latitude = tweet['coordinates'][0]

  if latitude >= DC_latitude_bounds['lower'] and latitude <= DC_latitude_bounds['higher']
    dc_tweet_count += 1
    # dc_tweets.insert(tweet)
  elsif latitude >= Houston_latitude_bounds['lower'] and latitude <= Houston_latitude_bounds['higher']
    houston_tweet_count += 1
    # houston_tweets.insert(tweet)
  else
   # Leave the tweet alone 
  end

end

puts 'DC: ' + dc_tweet_count.to_s
puts 'Houston: ' + houston_tweet_count.to_s
puts 'Combined: ' + dc_tweet_count + houston_tweet_count.to_s
puts 'Total Geotagged: ' + geotagged_tweets.count.to_s