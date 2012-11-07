require 'tweetstream'
require 'mongo'
require 'uri'

require_relative 'tweetstream_config'

# Sets up connection to Mongo database
puts ENV['MONGOHQ_URL']
db = URI.parse(ENV['MONGOHQ_URL'])
db_name = db.path.gsub(/^\//, '')
db = Mongo::Connection.new(db.host, db.port).db('ait_twitter_mining')

tweets = db.collection("test_tweets")

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
filter_params[:track] = Array['election']
filter_params[:locations] = Array[]

tweetstream_client.filter(filter_params) do |status|
  puts status.created_at.to_s
  puts status.place.full_name if status.place
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
