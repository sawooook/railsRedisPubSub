class RedisSubController < ApplicationController
  before_action :redis_connect

  def index

  end

  def redis_connect
    redis = Redis.new(host: "127.0.0.1", port: 6379)
    Thread.new do
      begin
        redis.subscribe(:redis,) do |on|
          on.subscribe do |channel, subscriptions|
            puts "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
          end

          on.message do |channel, message|
            puts "##{channel}: #{message}"
            redis.unsubscribe if message == "exit"
          end

          on.unsubscribe do |channel, subscriptions|
            puts "Unsubscribed from ##{channel} (#{subscriptions} subscriptions)"
          end
        end

      rescue Redis::BaseConnectionError => error
        puts "#{error}, retrying in 1s"
        sleep 1
        retry
      end
    end
  end
end
