require 'spec_helper'

describe Backframe::Response::Fields do

  it 'returns the default fields in the default order' do
    actual = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    expected = [
      { label: "id", key: "id" },
      { label: "first_name", key: "first_name" },
      { label: "last_name", key: "last_name" },
      { label: "email", key: "email" },
      { label: "photo.id", key: "photo.id" },
      { label: "photo.path", key: "photo.path" }
    ]
    expect(actual.any?).to eq(false)
    expect(actual.array).to eq(expected)
  end

  it 'returns the fields with an alternate order' do
    actual = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'last_name,first_name')
    expected = [
      { label: "last_name", key: "last_name" },
      { label: "first_name", key: "first_name" }
    ]
    expect(actual.array).to eq(expected)
  end

  it 'returns a field with an alias' do
    actual = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'First Name:first_name')
    expected = [
      { label: "First Name", key: "first_name" }
    ]
    expect(actual.array).to eq(expected)
  end

  it 'returns fields with mixed aliases' do
    actual = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'First Name:first_name,last_name')
    expected = [
      { label: "First Name", key: "first_name" },
      { label: "last_name", key: "last_name" }
    ]
    expect(actual.array).to eq(expected)
  end

end
