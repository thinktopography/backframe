require 'stringio'

module Backframe

  module ImageCache

    class Asset
      
      def initialize(filepath, conversions)
        @filepath = filepath
        @conversions = conversions
      end

      def process
        normalized = Backframe::ImageCache::Conversions.new(conversions)
        if filepath.present?
          fullpath = fullpath(filepath)
          content_type = content_type(filepath)
          data = download(fullpath)
          oriented = auto_orient(data)
          command = expand(normalized)
          converted = execute(oriented, command)
        else
          converted = default_asset
        end
        compressed = compress(converted)
        OpenStruct.new({ :success => true, :data => compressed, :content_type => content_type })
      end

      private

        attr_reader :filepath, :conversions

        def fullpath(path)
          File.exist?("#{Rails.root}/public/#{path}") ? "#{Rails.root}/public/#{path}" : "#{Rails.application.config.cdn_url}/#{path}"
        end

        def download(path)
          open(path).read
        end

        def auto_orient(data)
          execute(data, '-auto-orient')
        end

        def content_type(filepath)
          ext = extension(filepath)
          "image/#{ext}"
        end

        def extension(filepath)
          filepath.match(/.*\.([a-z]*)$/)[1]
        end

        def expand(conversions)
          command = []
          conversions.to_a.each do |conversion|
            if conversion.key?(:fit)
              width = conversion[:fit][:width] * conversion[:density]
              height = conversion[:fit][:height] * conversion[:density]
              command << "-resize \"#{width}x#{height}^\" -gravity center -crop '#{width}x#{height}+0+0'"
            elsif conversion.key?(:height)
              height = conversion[:height] * conversion[:density]
              command << "-resize \"x#{height}\""
            elsif conversion.key?(:width)
              width = conversion[:width] * conversion[:density]
              command << "-resize \"#{width}\""
            elsif conversion.key?(:crop)
              command << "-crop '#{parts[1]}x#{parts[2]}+#{parts[3]}+#{parts[4]}'"
            end
          end
          command.join(' ')
        end

        def default_asset
          path = "#{Rails.root}/tmp/canvas.png"
          command = "convert 10x10 canvas:#EEEEEE #{conversions} '#{path}'"
          Rails.logger.debug(command)
          output = `#{command}`
          IO.read(path)
        end

        #################### UTILITIES ####################

        def tmpfile(data)
          filename = SecureRandom.hex(32).to_s.upcase[0,8]
          tmpfile = Tempfile.new(filename, :encoding => 'ascii-8bit')
          tmpfile.write(data)
          tmpfile.close if tmpfile && !tmpfile.closed?
          tmpfile
        end

        def execute(data, command)
          tmpfile = tmpfile(data)
          command = "convert '#{tmpfile.path}' #{command} '#{tmpfile.path}'"
          Rails.logger.debug(command)
          output = `#{command}`
          IO.read(tmpfile.path)
        end

        def compress(data)
          ActiveSupport::Gzip.compress(data)
        end

    end

  end

end
