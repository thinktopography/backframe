ActiveRecord::Schema.define(version: 1) do
  create_table 'examples' do |t|
    t.string 'a'
    t.string 'b'
    t.string 'c'
    t.timestamps null: false
  end
end
