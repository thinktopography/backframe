require 'spec_helper'

describe Backframe::Adapter::Json do

  before(:all) do
    @contacts = [
      { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
      { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
    ]
  end

  it 'renders full payload' do
    fields = [
      { label: 'first_name', key: 'first_name' },
      { label: 'last_name', key: 'last_name' },
      { label: 'email', key: 'email' },
      { label: 'photo.id', key: 'photo.id' },
      { label: 'photo.path', key: 'photo.path' }
    ]
    actual = Backframe::Adapter::Json.render(@contacts, fields, 2)
    expected = {
      records: @contacts,
      total_records: 2
    }
    expect(actual).to eq(expected)
  end

  it 'renders with a single simple key' do
    fields = [
      { label: 'first_name', key: 'first_name' },
    ]
    actual = Backframe::Adapter::Json.render(@contacts, fields)
    expected = {
      records: [
        { first_name:'Greg' },
        { first_name:'Armand' }
      ],
      total_records: 2
    }
    expect(actual).to eq(expected)
  end

  it 'renders with a single nested key' do
    fields = [
      { label: 'photo.id', key: 'photo.id' },
    ]
    actual = Backframe::Adapter::Json.render(@contacts, fields)
    expected = {
      records: [
        { photo: { id: 1 } },
        { photo: { id: 2 } },
      ],
      total_records: 2
    }
    expect(actual).to eq(expected)
  end

  it 'renders with pagination' do
    fields = [
      { label: 'photo.id', key: 'photo.id' },
    ]
    actual = Backframe::Adapter::Json.render(@contacts, fields, 9, 1, 4)
    expected = {
      records: [
        { photo: { id: 1 } },
        { photo: { id: 2 } },
      ],
      total_records: 9,
      current_page: 1,
      total_pages: 4
    }
    expect(actual).to eq(expected)
  end

end
