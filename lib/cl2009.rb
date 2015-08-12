require 'cl2009/version'
require 'cl2009/configuration'
require 'uri'
require 'net/http'
require 'logger'
require 'redis'

module Cl2009
  class << self

    def setup
      yield config
    end

    def redis
      @redis ||= Redis.new(host: Cl2009.config.redis_host, port: Cl2009.config.redis_port)
    end

    def config
      @config ||= Configuration.new
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def sign_message(message)
      "#{Cl2009.config.sign}#{message}"
    end

    def increase_failed_message
      if redis.get('message_failed_count').nil?
        redis.set('message_failed_count', 1)
      else
        redis.incr('message_failed_count')
      end
    end

    def increase_successed_message
      if redis.get('message_successed_count').nil?
        redis.set('message_successed_count', 1)
      else
        redis.incr('message_successed_count')
      end
    end

    def send_message(message, mobile)
      uri = URI(Cl2009.config.send_server)
      params = { account: Cl2009.config.account, pswd: Cl2009.config.password, msg: sign_message(message), mobile: mobile }
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP.get_response(uri)
      if request.body.nil? || request.body.to_s.scan(',0').length != 1
        logger.debug "#{request.body}"
        increase_failed_message
        return false
      else
        logger.debug "send message to #{mobile}"
        increase_successed_message
        return true
      end
    end

    def send_messages_to_mobiles(message, mobiles = [])
      uri = URI(Cl2009.config.send_server)
      params = { account: Cl2009.config.account, pswd: Cl2009.config.password, msg: sign_message(message), mobile: mobiles.join(',') }
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP.get_response(uri)
      if request.body.nil? || request.body.to_s.scan(',0').length != 1
        logger.debug "#{request.body}"
        increase_failed_message
        return false
      else
        logger.debug "send message to #{mobiles.join(',')}"
        increase_successed_message
        return true
      end
    end

    def query_balance
      uri = URI(Cl2009.config.query_server)
      params = { account: Cl2009.config.account, pswd: Cl2009.config.password }
      uri.query = URI.encode_www_form(params)
      request = Net::HTTP.get_response(uri)
      request_data = request.body.to_s
      if request.body.nil? || request_data.scan(',0').length != 1
        logger.debug "#{request.body}"
        increase_failed_message
        return false
      else
        logger.debug "#{request_data[request_data.rindex(',')+1,request_data.length]}"
        increase_successed_message
        return request_data[request_data.rindex(',')+1,request_data.length].to_i
      end
    end

    def successed_messsage_count
      if redis.get('message_successed_count').nil?
        logger.debug "#{redis.get('message_successed_count')}"
        return 0
      else
        logger.debug "#{redis.get('message_successed_count')}"
        return redis.get('message_successed_count').to_i
      end
    end

    def failed_messsage_count
      if redis.get('message_failed_count').nil?
        logger.debug "#{redis.get('message_failed_count')}"
        return 0
      else
        logger.debug "#{redis.get('message_failed_count')}"
        return redis.get('message_failed_count').to_i
      end
    end

  end
end
