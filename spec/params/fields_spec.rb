require 'spec_helper'

describe Backframe::Params::Fields do

  before(:all) do
    @contacts = [
      { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
      { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
    ]
  end

  it 'returns the default fields in the default order' do
    actual = Backframe::Params::Fields.parse(@contacts.first)
    expected = [
      { label: "first_name", key: "first_name" },
      { label: "last_name", key: "last_name" },
      { label: "email", key: "email" },
      { label: "photo.id", key: "photo.id" },
      { label: "photo.path", key: "photo.path" }
    ]
    expect(actual).to eq(expected)
  end

end
