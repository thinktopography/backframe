require 'spec_helper'

describe Backframe::Service do

  describe 'service' do

    before(:all) do
      @greg = Backframe::Fixtures::Author.create(name: 'Greg Kops')
    end

    it 'succeeds' do
      result = Backframe::Fixtures::CreatePostService.perform({ title: 'Test Post With Author', author: @greg })
      expect(result.success?).to be(true)
      expect(result.post.title).to eq('Test Post With Author')
    end

    it 'fails' do
      result = Backframe::Fixtures::CreatePostService.perform({ title: 'Test Post Without Author'})
      expect(result.success?).to be(false)
    end

  end

end
