require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do

  self.verbose = false

  create_table :contacts, force: true do |t|
    t.string :first_name
    t.string :last_name
    t.string :email
    t.references :photo
    t.timestamps null: false
  end

  create_table :photos, force: true do |t|
    t.string :path
    t.timestamps null: false
  end

end
