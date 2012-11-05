require 'tweetstream'
require 'mongo'

require_relative 'tweetstream_config'

# Sets up connection to Mongo database
db = Mongo::Connection.from_uri(ENV['MONGOLAB_URI']).db("ait_twitter_mining")

tweets = db.collection("tweets")

tweetstream_client = TweetStream::Client.new()

# Handle delete and error messages 
tweetstream_client.on_delete do |status_id, user_id|
  puts "Removing #{status_id} from storage"
  tweets.remove({"status" => status_id})
end

tweetstream_client.on_error do |message|
  puts "Error received #{message}"
end


filter_params = Hash.new
filter_params[:track] = Array[
  '@BarackObama',
  '@MittRomney',
  '@PaulRyanVP',
  '@JoeBiden',
  'election',
  'Obama2012',
  'Romney2012',
  'MittRomney',
  'Romney',
  'Obama',
  'BarackObama',
  'POTUS',
  'GOP',
  'GOP2012',
  'DNC',
  'DNC2012',
  'RNC',
  'RNC2012',
  'ObamaBiden',
  'RomneyRyan',
  'ObamaBiden2012',
  'RomneyRyan2012',
  'PaulRyan',
  'JoeBiden',
  'conservatives',
  'liberals',
  'tcot',
  'tlot',
  'WhiteHouse',
]

# Bounding Box coordinates for Washington D.C. and Houston metro areas:
filter_params[:locations] = Array[
  -77.975464, 38.582526, # DC-SW-lon, DC-SW-lat,
  -76.760219, 39.253084, # DC-NE-lon, DC-NE-lat,
  -95.7301, 29.4862, # Houston-SW-lon, Houston-SW-lat,
  -94.8367, 30.4538 # Houston-NE-lon, Houston-NE-lat
]

tweetstream_client.filter(filter_params) do |status|
  tweet_data = {
    'status' => status.id,
    'created_at' => status.created_at,
    'text' => status.full_text,
    'hashtags' => status.hashtags.collect{|x| x.text},
    'mentions' => status.user_mentions.collect{|x| x.screen_name},
    'place' => (status.place && status.place.full_name) || nil,
    'coordinates' => (status.geo && status.geo.coordinates) || nil,
    'user' => status.from_user
  }
  tweets.insert(tweet_data)
end
