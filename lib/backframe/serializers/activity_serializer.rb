# encoding: utf-8

module Backframe
  class ActivitySerializer < ActiveModel::Serializer

    cache :key => :object
    attributes :id, :subject, :story, :object1, :object2, :created_at, :updated_at

    def subject
      if object.subject.present?
        { :link => object.subject.activity_link, :photo => (object.subject.photo.present?) ? object.subject.photo.url(:small) : nil, :text => object.subject.full_name }
      elsif object.subject_text.present?
        { :text => object.subject_text }
      else
        nil
      end
    end

    def story
      object.story.text
    end

    def object1
      if object.object1.present?
        { :link => object.object1.activity_link, :entity => object.object1.activity_entity, :text => object.object1.activity_text }
      elsif object.object1_text.present?
        { :text => object.object1_text }
      else
        nil
      end
    end

    def object2
      if object.object2.present?
        { :link => object.object2.activity_link, :entity => object.object2.activity_entity, :text => object.object2.activity_text }
      elsif object.object2_text.present?
        { :text => object.object2_text }
      else
        nil
      end
    end

  end
end