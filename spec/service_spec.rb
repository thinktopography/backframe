require 'spec_helper'

describe Backframe::Service do

  describe 'service' do

    it 'performs' do
      result = Backframe::Fixtures::CreatePostService.perform({ title: 'Test Post' })
      expect(result.success?).to be_truthy
    end

  end

end
