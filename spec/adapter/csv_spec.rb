require 'spec_helper'

describe Backframe::Adapter::Csv do

  describe 'csv adapter' do

    before do
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
      expected = {
        text: "first_name\nGreg\nArmand",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'renders with a nested key' do
      fields = [
        { label: 'photo.id', key: 'photo.id' },
      ]
      actual = Backframe::Adapter::Csv.render(@contacts, fields)
      expected = {
        text: "photo.id\n1\n2",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'it renders with specific keys in a specific order' do
      fields = [
        { label: 'last_name', key: 'last_name' },
        { label: 'first_name', key: 'first_name' }
      ]
      actual = Backframe::Adapter::Csv.render(@contacts, fields)
      expected = {
        text: "last_name,first_name\nKops,Greg\nZerilli,Armand",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

  end

end
