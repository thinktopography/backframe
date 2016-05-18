require 'stringio'

module Backframe

  module ImageCache

    class Cache
      
      def initialize(filepath, conversions)
        @filepath = filepath
        @conversions = conversions
      end

      def process
        begin
          test(filepath, conversions)
        rescue
          test(nil, conversions)
        end
      end

      def test(filepath, conversions)
        filekey = filepath || 'default.jpg'
        normalized = Backframe::ImageCache::Conversions.new(conversions)
        key = "imagecache/#{normalized.to_s}/#{filekey}"
        if !redis.get(key)
          asset = Backframe::ImageCache::Asset.new(filepath, normalized).process
          upload_to_s3(asset, key)
          save_to_redis(key)
        end
        return OpenStruct.new(:success => true, :url => "#{Rails.application.config.cdn_url}/#{key}")
      end

      private

        attr_reader :filepath, :conversions

        def save_to_redis(key)
          redis.set(key, true)
          redis.expire(key, (7 * 24 * 60 * 60))
        end

        def upload_to_s3(asset, key)
          headers = { :acl => 'public-read', :content_type => asset.content_type, :cache_control => 'max-age=315360000, no-transform, public', :content_encoding => 'gzip' }
          bucket = s3.buckets[aws['bucket']]
          bucket.objects.create(key, asset.data, headers)
        end

        def aws
          @aws ||= YAML.load_file("#{Rails.root}/config/aws.yml")[Rails.env]
        end

        def s3
          @s3 ||= AWS::S3.new(:access_key_id => aws['access_key_id'], :secret_access_key => aws['secret_access_key'])
        end

        def redis
          return @redis if @redis.present?
          config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
          @redis = Redis.new(:host => config['host'], :port => config['port'], :db => config[:cache])
        end

    end

  end

end
