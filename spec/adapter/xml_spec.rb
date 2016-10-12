require 'spec_helper'

describe Backframe::Adapter::Xml do

  describe 'xml adapter' do

    before do
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
      expected = {
        xml: '<?xml version="1.0"?><records><record><first_name>Greg</first_name></record><record><first_name>Armand</first_name></record></records>',
        content_type: "application/xhtml+xml",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'renders with a single nested key' do
      fields = [
        { label: 'photo.id', key: 'photo.id' },
      ]
      actual = Backframe::Adapter::Xml.render(@contacts, fields)
      expected = {
        xml: '<?xml version="1.0"?><records><record><photo.id>1</photo.id></record><record><photo.id>2</photo.id></record></records>',
        content_type: "application/xhtml+xml",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'wont render a non existant key' do
      fields = [
        { label: 'middle_name', key: 'middle_name' },
      ]
      actual = Backframe::Adapter::Xml.render(@contacts, fields)
      expected = {
        xml: '<?xml version="1.0"?><records><record></record><record></record></records>',
        content_type: "application/xhtml+xml",
        status: 200
      }
      expect(actual).to eq(expected)
    end

  end

end
