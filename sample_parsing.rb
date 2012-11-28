require 'mongo'

# Sets up connection to Mongo database
db = Mongo::Connection.new.db("ait_twitter_mining")

tweets = db.collection("geotagged")
geotagged_tweets = db.collection("geotagged")

DC_latitude_bounds = {'lower' => 38.582526, 'higher' => 39.253084}
Houston_latitude_bounds = {'lower' => 29.4862, 'higher' => 30.4538}

dc_tweet_count = 0
houston_tweet_count = 0

geotagged_tweets.find.each do |tweet|
  latitude = tweet['coordinates'][0]

  if latitude >= DC_latitude_bounds['lower'] and latitude <= DC_latitude_bounds['higher']
    dc_tweet_count += 1
  elsif latitude >= Houston_latitude_bounds['lower'] and latitude <= Houston_latitude_bounds['higher']
    houston_tweet_count += 1
  else
   # Do nothing 
  end

end

puts 'DC: ' + dc_tweet_count.to_s
puts 'Houston: ' + houston_tweet_count.to_s
puts 'Combined: ' + (dc_tweet_count + houston_tweet_count).to_s
puts 'Total Geotagged: ' + geotagged_tweets.count.to_s