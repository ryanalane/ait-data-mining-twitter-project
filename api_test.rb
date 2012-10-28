require 'tweetstream'
require 'mongo'

require_relative 'tweetstream_config'

# Sets up connection to local Mongo database
db = Mongo::Connection.new.db("ait_twitter_mining")

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
filter_params[:track] = Array['photography']

tweetstream_client.filter(filter_params) do |status|
  puts "#{status.text} - #{status.created_at}"
  puts status
#  tweets.insert(status)
end
