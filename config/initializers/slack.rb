Slack.configure do |config|
  config.token = ENV.fetch('SLACK_OAUTH_ACCESS_TOKEN') { '*****' }
end