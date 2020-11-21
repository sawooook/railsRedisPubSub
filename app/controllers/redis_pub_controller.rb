class RedisPubController < ApplicationController
  before_action :redis_connect


  def create
    puts redis_params
    puts "create Success"
    @redis.publish("redis", redis_params[:message])
  end

  def new
  end

  def redis_connect
    @redis = Redis.new(host: "127.0.0.1", port: 6379)
  end

  private

  def redis_params
    params.permit(:message)
  end
end
