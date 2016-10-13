require 'active_record'

module Backframe

  module Fixtures

    class Contact < ActiveRecord::Base

      belongs_to :photo

      validates :first_name, presence: true
      validates :last_name, presence: true
      validates :email, presence: true

    end

    class Photo < ActiveRecord::Base

      has_one :contact

    end

  end

end
