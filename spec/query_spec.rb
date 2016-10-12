require 'spec_helper'

describe Backframe::Query do

  describe 'query' do

    before(:all) do
      @greg = Backframe::Fixtures::Author.create(name: 'Greg Kops')
      @megan = Backframe::Fixtures::Author.create(name: 'Megan Pugh')
      @post1 = Backframe::Fixtures::Post.create(title: 'Post 1', body: '<p>This is a post</p>', author: @greg)
      @post2 = Backframe::Fixtures::Post.create(title: 'Post 2', body: '<p>This is another post</p>', author: @greg)
      @post3 = Backframe::Fixtures::Post.create(title: 'Post 3', body: '<p>This is another post</p>', author: @megan)
    end

    it 'can filter' do
      records = Backframe::Fixtures::PostQuery.perform({ title: 'Post 1' })
      expect(records.count).to eq(1)
      expect(records.first.id).to eq(@post1.id)

      records = Backframe::Fixtures::PostQuery.perform({ author_id: @greg.id })
      expect(records.count).to eq(2)

      records = Backframe::Fixtures::PostQuery.perform({ author_id: @megan.id })
      expect(records.count).to eq(1)
    end

    it 'can sort on a single field ascending' do
      records = Backframe::Fixtures::PostQuery.perform({ sort: 'created_at' })
      expect(records.first.id).to eq(@post1.id)
    end

    it 'can sort on a single field descending' do
      records = Backframe::Fixtures::PostQuery.perform({ sort: '-created_at' })
      expect(records.first.id).to eq(@post3.id)
    end

    it 'can sort on multiple fields with mixed order' do
      records = Backframe::Fixtures::PostQuery.perform({ sort: '-author_id,created_at' })
      expect(records[0].id).to eq(@post3.id)
      expect(records[1].id).to eq(@post1.id)
      expect(records[2].id).to eq(@post2.id)
    end

  end

end
