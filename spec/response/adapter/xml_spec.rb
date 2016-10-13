require 'spec_helper'

describe Backframe::Response::Adapter::Xml do

  it 'renders full payload' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Xml.render(collection, fields)
    expected = [
      '<?xml version="1.0"?><records>',
      '<record><id>1</id><first_name>Greg</first_name><last_name>Kops</last_name><email>greg@thinktopography.com</email><photo.id>1</photo.id><photo.path>/images/greg.jpg</photo.path></record>',
      '<record><id>2</id><first_name>Megan</first_name><last_name>Pugh</last_name><email>megan@thinktopography.com</email><photo.id>2</photo.id><photo.path>/images/megan.jpg</photo.path></record>',
      '<record><id>3</id><first_name>Kath</first_name><last_name>Tibbetts</last_name><email>kath@thinktopography.com</email><photo.id>3</photo.id><photo.path>/images/kath.jpg</photo.path></record>',
      '<record><id>4</id><first_name>Armand</first_name><last_name>Zerilli</last_name><email>armand@thinktopography.com</email><photo.id>4</photo.id><photo.path>/images/armand.jpg</photo.path></record>',
      '</records>'
    ].join
    expect(actual).to eq(expected)
  end

  it 'renders with a single simple key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'first_name')
    actual = Backframe::Response::Adapter::Xml.render(collection, fields)
    expected = [
      '<?xml version="1.0"?><records>',
      '<record><first_name>Greg</first_name></record>',
      '<record><first_name>Megan</first_name></record>',
      '<record><first_name>Kath</first_name></record>',
      '<record><first_name>Armand</first_name></record>',
      '</records>'
    ].join
    expect(actual).to eq(expected)
  end

  it 'renders with a single nested key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'photo.id')
    actual = Backframe::Response::Adapter::Xml.render(collection, fields)
    expected = [
      '<?xml version="1.0"?><records>',
      '<record><photo.id>1</photo.id></record>',
      '<record><photo.id>2</photo.id></record>',
      '<record><photo.id>3</photo.id></record>',
      '<record><photo.id>4</photo.id></record>',
      '</records>'
    ].join
    expect(actual).to eq(expected)
  end

  it 'renders with pagination' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, 1, 2)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Xml.render(collection, fields)
    expected = [
      '<?xml version="1.0"?><records>',
      '<record><id>1</id><first_name>Greg</first_name><last_name>Kops</last_name><email>greg@thinktopography.com</email><photo.id>1</photo.id><photo.path>/images/greg.jpg</photo.path></record>',
      '<record><id>2</id><first_name>Megan</first_name><last_name>Pugh</last_name><email>megan@thinktopography.com</email><photo.id>2</photo.id><photo.path>/images/megan.jpg</photo.path></record>',
      '</records>'
    ].join
    expect(actual).to eq(expected)
  end

end
