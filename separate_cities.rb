require 'mongo'

# Sets up connection to Mongo database
db = Mongo::Connection.new.db("ait_twitter_mining")

geotagged_tweets = db.collection("geotagged")

DC_latitude_bounds = {'lower' => 38.582526, 'higher' => 39.253084}
Houston_latitude_bounds = {'lower' => 29.4862, 'higher' => 30.4538}

geotagged_tweets.find.each do |tweet|
  latitude = tweet['coordinates'][0]

  if latitude >= DC_latitude_bounds['lower'] and latitude <= DC_latitude_bounds['higher']
    puts 'DC!'
  else
    puts '?'
  end

end