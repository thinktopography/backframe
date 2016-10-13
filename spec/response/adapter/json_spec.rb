require 'spec_helper'

describe Backframe::Response::Adapter::Json do

  before(:all) do
    @records = [
      { id: 1, first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
      { id: 2, first_name: 'Megan', last_name: 'Pugh', email: 'megan@thinktopography.com', photo: { id: 2, path: '/images/megan.jpg' } },
      { id: 3, first_name: 'Kath', last_name: 'Tibbetts', email: 'kath@thinktopography.com', photo: { id: 3, path: '/images/kath.jpg' } },
      { id: 4, first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 4, path: '/images/armand.jpg' } }
    ]
  end

  it 'renders full payload' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Json.render(collection, fields)
    expected = {
      records: @records,
      total_records: 4,
      current_page: 1,
      total_pages: 1
    }
    expect(actual).to eq(expected)
  end

  it 'renders with a single simple key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'first_name')
    actual = Backframe::Response::Adapter::Json.render(collection, fields)
    expected = {
      records: @records.map { |r| { first_name: r[:first_name] } },
      total_records: 4,
      current_page: 1,
      total_pages: 1
    }
    expect(actual).to eq(expected)
  end

  it 'renders with a single nested key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'photo.id')
    actual = Backframe::Response::Adapter::Json.render(collection, fields)
    expected = {
      records: @records.map { |r| { photo: { id: r[:photo][:id] } } },
      total_records: 4,
      current_page: 1,
      total_pages: 1
    }
    expect(actual).to eq(expected)
  end

  it 'renders with pagination' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, 1, 2)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Json.render(collection, fields)
    expected = {
      records: @records[0, 2],
      total_records: 4,
      current_page: 1,
      total_pages: 2
    }
    expect(actual).to eq(expected)
  end

end
