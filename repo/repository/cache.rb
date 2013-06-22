require 'redis'

module Geronimo
  module Repository
    module Cache
      def self.redis
        @redis ||= Redis.new
      end

      def self.cache(key)
        v = redis.get(key)
        return JSON.parse(v) if v
        v = yield
        redis.set(key, v.to_json)
        v
      end
    end
  end
end
