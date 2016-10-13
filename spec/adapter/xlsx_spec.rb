require 'spec_helper'

describe Backframe::Adapter::Xlsx do

  before(:all) do
    @contacts = [
      { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
      { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
    ]
  end

  it 'renders with a single simple key' do
    fields = [
      { label: 'first_name', key: 'first_name' },
    ]
    actual = Backframe::Adapter::Xlsx.render(@contacts, fields)
    expected = nil
    # expect(actual).to eq(expected)
  end

  it 'renders with a single nested key' do
    fields = [
      { label: 'photo.id', key: 'photo.id' },
    ]
    actual = Backframe::Adapter::Xlsx.render(@contacts, fields)
    expected = nil
    # expect(actual).to eq(expected)
  end

end
