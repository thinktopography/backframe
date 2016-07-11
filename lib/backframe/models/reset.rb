# encoding: utf-8

module Backframe
  class Reset < ActiveRecord::Base

    liquid_methods :code, :url

    belongs_to :user, :polymorphic => true

    validates_presence_of :user, :token

    after_initialize :init, :if => Proc.new { |o| o.new_record? }
    after_create :enforce_uniqueness
    after_commit :send_email

    def claim
      self.claimed_at = Time.zone.now
      self.is_active = false
      self.save
      self.user.update_attributes(:is_active => true, :activated_at => Time.zone.now)
    end

    def expired?
      !self.is_active
    end

    def url
      return "#{Rails.application.config.root_url}/admin/reset/#{self.token}"   if self.user_type == 'Admin'
      return "#{Rails.application.config.root_url}/account/reset/#{self.token}" if self.user_type == 'Customer'
    end

    private

      def init
        self.token ||= SecureRandom.hex(32).to_s.upcase[0,32]
        self.is_active = true
      end

      def set_active
        self.is_active = true
      end

      def enforce_uniqueness
        self.user.resets.where('id != ?', self.id).update_all(:is_active => false)
      end

      def send_email
        if self.user_type == 'Admin'
          ApplicationMailer.reset(self).deliver_now!
        elsif self.user_type == 'Customer'
          template = EmailTemplate.find_by(:code => 'password_reset')
          email = EmailDelivery.new(:customer => self.user, :subject => template.subject, :body => template.body)
          email.personalize(:customer => self.user, :reset => self)
          email.save
        end
      end

  end
end