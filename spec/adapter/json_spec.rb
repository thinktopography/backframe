require 'spec_helper'

describe Backframe::Adapter::Json do

  describe 'json adapter' do

    before do
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
      actual = Backframe::Adapter::Json.render(@contacts, fields)
      expected = {
        json: @contacts,
        content_type: "application/json",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'renders with a single simple key' do
      fields = [
        { label: 'first_name', key: 'first_name' },
      ]
      actual = Backframe::Adapter::Json.render(@contacts, fields)
      expected = {
        json: [
          { first_name:'Greg' },
          { first_name:'Armand' }
        ],
        content_type: "application/json",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'renders with a single nested key' do
      fields = [
        { label: 'photo.id', key: 'photo.id' },
      ]
      actual = Backframe::Adapter::Json.render(@contacts, fields)
      expected = {
        json: [
          { photo: { id: 1 } },
          { photo: { id: 2 } },
        ],
        content_type: "application/json",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'wont render a non existant key' do
      fields = [
        { label: 'middle_name', key: 'middle_name' },
      ]
      actual = Backframe::Adapter::Json.render(@contacts, fields)
      expected = {
        json: [{},{}],
        content_type: "application/json",
        status: 200
      }
      expect(actual).to eq(expected)
    end

  end

end
