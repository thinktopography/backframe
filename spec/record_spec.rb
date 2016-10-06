require 'spec_helper'

describe Backframe::Record do

  describe 'record' do

    before do
      @hash = { first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } }
    end

    it 'casts a string path' do
      actual = Backframe::Record.cast_path('a')
      expected = ['a']
      expect(actual).to eq(expected)
    end

    it 'casts a nested string path' do
      actual = Backframe::Record.cast_path('a.b.c')
      expected = ['a','b','c']
      expect(actual).to eq(expected)
    end

    it 'casts a symbol path' do
      actual = Backframe::Record.cast_path(:a)
      expected = ['a']
      expect(actual).to eq(expected)
    end

    it 'casts an array path' do
      actual = Backframe::Record.cast_path(['a'])
      expected = ['a']
      expect(actual).to eq(expected)
    end

    it 'gets top level value' do
      actual = Backframe::Record.get_value(@hash, 'first_name')
      expected = 'Greg'
      expect(actual).to eq(expected)
    end

    it 'gets nested value' do
      actual = Backframe::Record.get_value(@hash, 'photo.id')
      expected = 1
      expect(actual).to eq(expected)
    end

    it 'flattens keys' do
      actual = Backframe::Record.keys(@hash)
      expected = ['first_name', 'last_name', 'email', 'photo.id', 'photo.path']
      expect(actual).to eq(expected)
    end


  end

end
