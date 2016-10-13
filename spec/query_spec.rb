require 'spec_helper'

describe Backframe::Query do

  before(:all) do
    @contact = Backframe::Fixtures::Contact
    @greg = @contact.find(1)
    @megan = @contact.find(2)
    @kath = @contact.find(3)
    @armand = @contact.find(4)
  end

  it 'can filter' do
    records = Backframe::Fixtures::ContactQuery.perform(@contact, { first_name: 'Greg' })
    expect(records.count).to eq(1)
    expect(records.first.id).to eq(@greg.id)
  end

  it 'can sort on a single field ascending' do
    records = Backframe::Fixtures::ContactQuery.perform(@contact, { sort: 'created_at' })
    expect(records.first.id).to eq(@greg.id)
  end

  it 'can sort on a single field descending' do
    records = Backframe::Fixtures::ContactQuery.perform(@contact, { sort: '-created_at' })
    expect(records.first.id).to eq(@armand.id)
  end

  # it 'can sort on multiple fields with mixed order' do
  #   post = Backframe::Fixtures::Post
  #   records = Backframe::Fixtures::PostQuery.perform(post, { sort: '-author_id,created_at' })
  #   expect(records[0].id).to eq(@post3.id)
  #   expect(records[1].id).to eq(@post1.id)
  #   expect(records[2].id).to eq(@post2.id)
  # end
  #
  # it 'ignore invalid sort' do
  #   post = Backframe::Fixtures::Post
  #   records = Backframe::Fixtures::PostQuery.perform(post, { sort: '123^' })
  #   ids = records.all.map { |r| r.id }
  #   expect(ids).to eq([1,2,3])
  # end
  #
  # it 'can exclude_ids' do
  #   post = Backframe::Fixtures::Post
  #   records = Backframe::Fixtures::PostQuery.perform(post, { exclude_ids: '1,2' })
  #   ids = records.all.map { |r| r.id }
  #   expect(ids).not_to include(1)
  #   expect(ids).not_to include(2)
  #   expect(ids).to include(3)
  # end
  #
  # it 'ignore invalid exclude_ids' do
  #   post = Backframe::Fixtures::Post
  #   records = Backframe::Fixtures::PostQuery.perform(post, { exclude_ids: '1,b,c' })
  #   ids = records.all.map { |r| r.id }
  #   expect(ids).to eq([1,2,3])
  # end

end
