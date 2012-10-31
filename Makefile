all: config, logs

config:
	cp tweetstream_config.rb.default tweetstream_config.rb

logs:
	mkdir logs
