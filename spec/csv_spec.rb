require 'spec_helper'

describe Backframe::Response::Csv do

  describe 'csv response adapter' do

    it 'it renders with defaults' do
      contacts = [
        { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
        { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
      ]
      actual = Backframe::Response::Csv.render(contacts)
      expected = {
        text: "first_name,last_name,email,photo.id,photo.path\nGreg,Kops,greg@thinktopography.com,1,/images/greg.jpg\nArmand,Zerilli,armand@thinktopography.com,2,/images/armand.jpg",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'it renders with nested objects' do
      contacts = [
        { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
        { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
      ]
      actual = Backframe::Response::Csv.render(contacts, ['photo.id'])
      expected = {
        text: "photo.id\n1\n2",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'it renders with specific keys in a specific order' do
      contacts = [
        { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
        { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
      ]
      actual = Backframe::Response::Csv.render(contacts, [:last_name, :first_name])
      expected = {
        text: "last_name,first_name\nKops,Greg\nZerilli,Armand",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

  end
end
