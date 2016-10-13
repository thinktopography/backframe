require 'spec_helper'

describe Backframe::Response::Adapter::Xml do

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
    actual = Backframe::Adapter::Xml.render(@contacts, fields)
    expected = '<?xml version="1.0"?><records><record><first_name>Greg</first_name></record><record><first_name>Armand</first_name></record></records>'
    expect(actual).to eq(expected)
  end

  it 'renders with a single nested key' do
    fields = [
      { label: 'photo.id', key: 'photo.id' },
    ]
    actual = Backframe::Adapter::Xml.render(@contacts, fields)
    expected = '<?xml version="1.0"?><records><record><photo.id>1</photo.id></record><record><photo.id>2</photo.id></record></records>'
    expect(actual).to eq(expected)
  end

end
