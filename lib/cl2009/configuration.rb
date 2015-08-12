module Cl2009
  class Configuration
    def send_server
      @send_server ||= "http://222.73.117.158/msg/HttpBatchSendSM"
    end

    def send_server=(send_server)
      @send_server = send_server
    end

    def query_server
      @query_server ||= "http://222.73.117.158/msg/QueryBalance"
    end

    def query_server=(query_server)
      @query_server = query_server
    end

    def account
      @account ||= "account"
    end

    def account=(account)
      @account = account
    end

    def password
      @password ||= "password"
    end

    def password=(password)
      @password = password
    end

    def sign
      @sign
    end

    def sign=(sign)
      @sign = "【#{sign}】"
    end

    def redis_host
      @redis_host ||= "redis_host"
    end

    def redis_host=(redis_host)
      @redis_host = redis_host
    end

    def redis_port
      @redis_port ||= "redis_port"
    end

    def redis_port=(redis_port)
      @redis_port = redis_port
    end

  end
end