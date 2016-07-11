# encoding: utf-8

module Backframe
  class Story < ActiveRecord::Base

    has_many :activities

  end
end
