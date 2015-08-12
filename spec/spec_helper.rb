require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'bundler/setup'
require 'cl2009'

Bundler.setup

Cl2009.setup do |config|
  config.send_server = "http://222.73.117.158/msg/HttpBatchSendSM"
  config.query_server = "http://222.73.117.158/msg/QueryBalance"
  config.account = "jiekou-clcs-005"
  config.password = "Clwh1681688"
  config.redis_host = "localhost"
  config.redis_port = "6379"
  config.sign = "测试"
end

RSpec.configure do |config|
  config.before(:each) do
  end
end
