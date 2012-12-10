require 'mongo'

# Sets up connection to Mongo database
db = Mongo::Connection.new.db("ait_twitter_mining")

utc_collections = {'dc' => db.collection("dc_tweets"), 'houston' => db.collection("houston_tweets")}
local_collections = {'dc' => db.collection("dc_tweets_local"), 'houston' => db.collection("houston_tweets_local")}
utc_offsets = {'dc' => -5 * 3600, 'houston' => -6 * 3600}

utc_collections.each_key do |city|

  utc_collections[city].find.each do |tweet|
    tweet['created_at'] = tweet['created_at'] + utc_offsets[city]
    puts tweet['created_at']
    local_collections[city].insert(tweet)
  end

end