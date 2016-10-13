require 'spec_helper'

describe Backframe::Query do

  before(:all) do
    @greg  = Backframe::Fixtures::Author.create(name: 'Greg Kops')
    @megan = Backframe::Fixtures::Author.create(name: 'Megan Pugh')
    @post1 = Backframe::Fixtures::Post.create(title: 'Post 1', body: '<p>This is a post</p>', author: @greg)
    @post2 = Backframe::Fixtures::Post.create(title: 'Post 2', body: '<p>This is another post</p>', author: @greg)
    @post3 = Backframe::Fixtures::Post.create(title: 'Post 3', body: '<p>This is another post</p>', author: @megan)
  end

  it 'can filter' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { title: 'Post 1' })
    expect(records.count).to eq(1)
    expect(records.first.id).to eq(@post1.id)

    records = Backframe::Fixtures::PostQuery.perform(post, { author_id: @greg.id })
    expect(records.count).to eq(2)

    records = Backframe::Fixtures::PostQuery.perform(post, { author_id: @megan.id })
    expect(records.count).to eq(1)
  end

  it 'can sort on a single field ascending' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { sort: 'created_at' })
    expect(records.first.id).to eq(@post1.id)
  end

  it 'can sort on a single field descending' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { sort: '-created_at' })
    expect(records.first.id).to eq(@post3.id)
  end

  it 'can sort on multiple fields with mixed order' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { sort: '-author_id,created_at' })
    expect(records[0].id).to eq(@post3.id)
    expect(records[1].id).to eq(@post1.id)
    expect(records[2].id).to eq(@post2.id)
  end

  it 'ignore invalid sort' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { sort: '123^' })
    ids = records.all.map { |r| r.id }
    expect(ids).to eq([1,2,3])
  end

  it 'can exclude_ids' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { exclude_ids: '1,2' })
    ids = records.all.map { |r| r.id }
    expect(ids).not_to include(1)
    expect(ids).not_to include(2)
    expect(ids).to include(3)
  end

  it 'ignore invalid exclude_ids' do
    post = Backframe::Fixtures::Post
    records = Backframe::Fixtures::PostQuery.perform(post, { exclude_ids: '1,b,c' })
    ids = records.all.map { |r| r.id }
    expect(ids).to eq([1,2,3])
  end

end
