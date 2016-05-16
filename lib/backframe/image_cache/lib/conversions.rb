require 'stringio'

module Backframe

  module ImageCache

    class Conversions
      
      def initialize(conversions)
        @conversions = normalize_conversions(conversions)
      end

      def to_s
        output = []
        conversions.each do |conversion|
          if conversion.key?(:fit)
            output << "F#{conversion[:fit][:width]}X#{conversion[:fit][:height]}D#{conversion[:density]}"
          elsif conversion.key?(:width)
            output << "W#{conversion[:width]}D#{conversion[:density]}"
          elsif conversion.key?(:height)
            output << "H#{conversion[:height]}D#{conversion[:density]}"
          elsif conversion.key?(:crop)
            output << "C#{conversion[:crop][:width]}X#{conversion[:crop][:height]}X#{conversion[:crop][:x]}X#{conversion[:crop][:y]}D#{conversion[:density]}"
          end
        end
        output.join("-")
      end

      def to_a
        conversions
      end

      private

        attr_reader :conversions

        #################### CONVERSION HANDLING ####################

        def normalize_conversions(conversions)
          if conversions.is_a?(String)
            return normalize_conversion_string(conversions)
          elsif conversions.is_a?(Symbol)
              return normalize_conversion_string(conversions.to_s)
          elsif conversions.is_a?(Hash)
            return normalize_conversion_array([conversions])
          elsif conversions.is_a?(Array)
            return normalize_conversion_array(conversions)
          elsif conversions.is_a?(Backframe::ImageCache::Conversions)
            return conversions.to_a
          end
        end

      def normalize_conversion_string(string)
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
            density = (matches[3]) ? matches[4] : 1
            output << { :fit => { :width => matches[1].to_i, :height => matches[2].to_i }, :density => density.to_i }
          elsif matches = part.match(/^W(\d*)(D(\d*))?$/)
            density = (matches[2]) ? matches[3] : 1
            output << { :width => matches[1].to_i, :density => density.to_i }
          elsif matches = part.match(/^H(\d*)(D(\d*))?$/)
            density = (matches[2]) ? matches[3] : 1
            output << { :height => matches[1].to_i, :density => density.to_i }
          elsif matches = part.match(/^C(\d*)X(\d*)X(\d*)X(\d*)(D(\d*))?$/)
            density = (matches[4]) ? matches[5] : 1
            output << { :crop => { :width => matches[1].to_i, :height => matches[2].to_i, :x => matches[3].to_i, :y => matches[4].to_i, :density => density.to_i } }
          end
        end
        output
      end

      def normalize_conversion_array(array)
        output = []
        array.each do |conversion|
          density = conversion[:density].to_i || 1
          if conversion.key?(:preview)
            output << { :width => 250, :density => density }
          elsif conversion.key?(:tiny)
            output << { :fit => { :width => 20, :height => 20 }, :density => density }
          elsif conversion.key?(:small)
            output << { :fit => { :width => 40, :height => 40 }, :density => density }
          elsif conversion.key?(:medium)
            output << { :fit => { :width => 250, :height => 250 }, :density => density }
          elsif conversion.key?(:fit)
            fit = (conversion[:fit].is_a?(String)) ? parse_geometry_string(conversion[:fit]) : parse_geometry_array(conversion[:fit])
            output << { :fit => fit, :density => density }
          elsif conversion.key?(:width)
            output << { :width => conversion[:width].to_i, :density => density }
          elsif conversion.key?(:height)
            output << { :height => conversion[:height].to_i, :density => density }
          elsif conversion.key?(:crop)
            crop = (conversion[:crop].is_a?(String)) ? parse_geometry(conversion[:crop]) : parse_geometry_array(conversion[:crop])
            output << { :crop => crop, :density => density }
          end
        end
        output
      end

      def parse_geometry_string(string)
        string = string.upcase
        if matches = string.match(/^(\d*)X(\d*)$/)
          { :width => matches[1].to_i, :height => matches[2].to_i }
        elsif matches = string.match(/^(\d*)X(\d*)X(\d*)X(\d*)$/)
          { :width => matches[1].to_i, :height => matches[2].to_i, :x => matches[3].to_i, :y => matches[4].to_i }
        elsif matches = string.match(/^(\d*)X(\d*)\+(\d*)\+(\d*)$/)
          { :width => matches[1].to_i, :height => matches[2].to_i, :x => matches[3].to_i, :y => matches[4].to_i }
        end
      end

      def parse_geometry_array(array)
        output = {}
        output[:width] = array[:width].to_i if array.key?(:width)
        output[:height] = array[:height].to_i if array.key?(:height)
        output[:x] = array[:x].to_i if array.key?(:x)
        output[:y] = array[:y].to_i if array.key?(:y)
        output
      end

    end

  end

end
