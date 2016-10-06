require 'spec_helper'

describe Backframe::Params::Sort do

  describe 'record' do

    it 'returns the default sort order' do
      actual = Backframe::Params::Sort.parse()
      expected = [
        { key: 'created_at', order: 'DESC' },
      ]
      expect(actual).to eq(expected)
    end

    it 'returns a simple asecnding sort order' do
      actual = Backframe::Params::Sort.parse('first_name')
      expected = [
        { key: 'first_name', order: 'ASC' },
      ]
      expect(actual).to eq(expected)
    end

    it 'returns a simple desecnding sort order' do
      actual = Backframe::Params::Sort.parse('-first_name')
      expected = [
        { key: 'first_name', order: 'DESC' },
      ]
      expect(actual).to eq(expected)
    end

    it 'returns a complex mixed sort order' do
      actual = Backframe::Params::Sort.parse('first_name,-last_name')
      expected = [
        { key: 'first_name', order: 'ASC' },
        { key: 'last_name', order: 'DESC' }
      ]
      expect(actual).to eq(expected)
    end

    it 'doesnt care about spaces' do
      actual = Backframe::Params::Sort.parse(' first_name , last_name ')
      expected = [
        { key: 'first_name', order: 'ASC' },
        { key: 'last_name', order: 'ASC' }
      ]
      expect(actual).to eq(expected)
    end

  end

end
