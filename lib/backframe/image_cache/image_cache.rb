require 'backframe/image_cache/lib/asset'
require 'backframe/image_cache/lib/cache'
require 'backframe/image_cache/lib/conversions'

module Backframe

  module ImageCache

    class Base

      def asset(filepath, conversions)
        Backframe::ImageCache::Asset.new(filepath, conversions).process
      end

      def cached(filepath, conversions)
        Backframe::ImageCache::Cache.new(filepath, conversions).process
      end

      def path(filepath, conversions)
        string = Backframe::ImageCache::Conversions.new(conversions).to_s
        filekey = filepath || 'default.jpg'
        "/imagecache/#{string}/#{filekey}"
      end

      def url(filepath, conversions)
        Rails.application.config.root_url + path(filepath, conversions)
      end

      def http_url(filepath, conversions)
        url(filepath, conversions).gsub('https', 'http')
      end

      def cdn_url(filepath, conversions)
        Rails.application.config.cdn_url + path(filepath, conversions)
      end

      def http_cdn_url(filepath, conversions)
        cdn_url(filepath, conversions).gsub('https', 'http')
      end

    end

  end

end
