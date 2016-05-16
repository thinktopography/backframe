require 'stringio'

module Backframe

  class ImageCache

    def initialize(filepath, conversions)
      @filepath = filepath
      @conversions = conversions
    end

    def process!
      normalized = normalize_conversions(conversions)
      fullpath = fullpath(filepath)
      content_type = content_type(filepath)
      data = download(fullpath)
      oriented = auto_orient(data)
      dimensions = dimensions(oriented)
      command = expand(normalized)
      converted = execute(oriented, command)
      OpenStruct.new({ :success => true, :data => converted, :content_type => content_type })
    end

    private

    attr_reader :filepath, :conversions

    #################### CONVERSION HANDLING ####################

    def normalize_conversions(string)
      output = []
      string.upcase.split("-").each do |part|
        if part == 'PREVIEW'
          output << { :width => 250, :density => 2 }
        elsif part == 'TINY'
          output << { :fit => { :width => 20, :height => 20 }, :density => 2 }
        elsif part == 'SMALL'
          output << { :fit => { :width => 40, :height => 40 }, :density => 2 }
        elsif part == 'MEDIUM'
          output << { :fit => { :width => 250, :height => 250 }, :density => 2 }
        elsif matches = part.match(/^F(\d*)X(\d*)(D(\d*))?$/)
          density = (matches[3]) ? matches[4].to_i : 1
          output << { :fit => { :width => matches[1].to_i, :height => matches[2].to_i }, :density => density }
        elsif matches = part.match(/^W(\d*)(D(\d*))?$/)
          density = (matches[2]) ? matches[3].to_i : 1
          output << { :width => matches[1].to_i, :density => density }
        elsif matches = part.match(/^H(\d*)(D(\d*))?$/)
          density = (matches[2]) ? matches[3].to_i : 1
          output << { :height => matches[1].to_i, :density => density }
        elsif matches = part.match(/^C(\d*)X(\d*)X(\d*)X(\d*)(D(\d*))?$/)
          density = (matches[4]) ? matches[5].to_i : 1
          output << { :crop => { :width => matches[1].to_i, :height => matches[2].to_i, :x => matches[3].to_i, :y => matches[4].to_i, :density => density } }
        end
      end
      output
    end

    #################### ASSET HANDLING ####################

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

    def dimensions(data)
      tmpfile = tmpfile(data)
      command = "identify -format '%wx%h,%[exif:orientation]' '#{tmpfile.path}'"
      output = `#{command}`
      matches = output.match(/^(\d*)x(\d*)/)
      { :width => matches[1], :height => matches[2] }
    end

    def expand(conversions)
      command = []
      conversions.each do |conversion|
        if conversion.key?(:fit)
          width = conversion[:fit][:width] * conversion[:density]
          height = conversion[:fit][:height] * conversion[:density].to_i
          command << "-resize \"#{width}x#{height}^\" -gravity center -crop '#{width}x#{height}+0+0'"
        elsif conversion.key?(:height)
          height = conversion[:height] * conversion[:density].to_i
          command << "-resize \"x#{height}\""
        elsif conversion.key?(:width)
          width = conversion[:width] * conversion[:density].to_i
          command << "-resize \"#{width}\""
        elsif conversion.key?(:crop)
          command << "-crop '#{parts[1]}x#{parts[2]}+#{parts[3]}+#{parts[4]}'"
        end
      end
      command.join(' ')
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

  end

end
