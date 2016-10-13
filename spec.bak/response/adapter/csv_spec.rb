require 'spec_helper'

describe Backframe::Response::Adapter::Csv do

  before(:all) do
    @contacts = [
      { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
      { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
    ]
  end

  it 'renders with a simple key' do
    fields = [
      { label: 'first_name', key: 'first_name' },
    ]
    actual = Backframe::Adapter::Csv.render(@contacts, fields)
    expected = "first_name\nGreg\nArmand"
    expect(actual).to eq(expected)
  end

  it 'renders with a nested key' do
    fields = [
      { label: 'photo.id', key: 'photo.id' },
    ]
    actual = Backframe::Adapter::Csv.render(@contacts, fields)
    expected = "photo.id\n1\n2"
    expect(actual).to eq(expected)
  end

  it 'renders with specific keys in a specific order' do
    fields = [
      { label: 'last_name', key: 'last_name' },
      { label: 'first_name', key: 'first_name' }
    ]
    actual = Backframe::Adapter::Csv.render(@contacts, fields)
    expected = "last_name,first_name\nKops,Greg\nZerilli,Armand"
    expect(actual).to eq(expected)
  end

  it 'renders with a custom separator' do
    fields = [
      { label: 'last_name', key: 'last_name' },
      { label: 'first_name', key: 'first_name' }
    ]
    actual = Backframe::Adapter::Csv.render(@contacts, fields, '|')
    expected = "last_name|first_name\nKops|Greg\nZerilli|Armand"
    expect(actual).to eq(expected)
  end

end
