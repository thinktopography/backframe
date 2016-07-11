# encoding: utf-8

module Backframe
  class Activity < ActiveRecord::Base

    belongs_to :subject, :polymorphic => true
    belongs_to :object1, :polymorphic => true
    belongs_to :object2, :polymorphic => true
    belongs_to :story

    validates_presence_of :story, :subject

    default_scope -> { includes(:subject,:object1,:object2,:story).order(:created_at => :desc) }

    def text=(text)
      self.story = Backframe::Story.find_or_initialize_by(:text => text)
    end

    def subject=(object)
      self.subject_type = object.class.name
      self.subject_text = object.activity_text
      self.subject_id   = object.id
    end

    def object1=(object)
      self.object1_type = object.class.name
      self.object1_text = object.activity_text
      self.object1_id   = object.id
      object
    end

    def object2=(object)
      self.object2_type = object.class.name
      self.object2_text = object.activity_text
      self.object2_id   = object.id
      object
    end

  end
end