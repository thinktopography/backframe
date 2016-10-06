require 'spec_helper'

describe Backframe::Response do

  describe 'response' do

    before do
      @contacts = [
        { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
        { first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 2, path: '/images/armand.jpg' } }
      ]
    end

    it 'renders default csv response' do
      actual = Backframe::Response.index(@contacts, nil, 'csv')
      expected = {
        text: "first_name,last_name,email,photo.id,photo.path\nGreg,Kops,greg@thinktopography.com,1,/images/greg.jpg\nArmand,Zerilli,armand@thinktopography.com,2,/images/armand.jpg",
        content_type: "text/plain",
        status: 200
      }
      expect(actual).to eq(expected)
    end

    it 'renders error if no format provided' do
      actual = Backframe::Response.index(@contacts, nil, 'unknown')
      expected = {
        text: 'Unknown format',
        content_type: 'text/plain',
        status: 404
      }
      expect(actual).to eq(expected)
    end

  end

end
