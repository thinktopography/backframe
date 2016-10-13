require 'spec_helper'

describe Backframe::Response do

  before(:all) do
    @records = [
      { id: 1, first_name: 'Greg', last_name: 'Kops', email: 'greg@thinktopography.com', photo: { id: 1, path: '/images/greg.jpg' } },
      { id: 2, first_name: 'Megan', last_name: 'Pugh', email: 'megan@thinktopography.com', photo: { id: 2, path: '/images/megan.jpg' } },
      { id: 3, first_name: 'Kath', last_name: 'Tibbetts', email: 'kath@thinktopography.com', photo: { id: 3, path: '/images/kath.jpg' } },
      { id: 4, first_name: 'Armand', last_name: 'Zerilli', email: 'armand@thinktopography.com', photo: { id: 4, path: '/images/armand.jpg' } }
    ]
  end

  it 'renders error if no format provided' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'bat' })
    expected = {
      json: { error: { message: "Unknown Format", status: 404 } },
      content_type: 'application/json',
      status: 404
    }
    expect(actual).to eq(expected)
  end

  it 'renders plain' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'json' })
    expected = {
      json: {
        records: @records,
        total_records: 4,
        current_page: 1,
        total_pages: 1
      },
      content_type: 'application/json',
      status: 200
    }
    expect(actual).to eq(expected)
  end

  it 'renders with pagination' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'json', page: 1,  per_page: 2 })
    expected = {
      json: {
        records: @records[0, 2],
        total_records: 4,
        current_page: 1,
        total_pages: 2
      },
      content_type: 'application/json',
      status: 200
    }
    expect(actual).to eq(expected)
  end

  it 'renders with fields' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'json', fields: 'First Name:first_name' })
    expected = {
      json: {
        records: @records.map { |r| { first_name: r[:first_name]} },
        total_records: 4,
        current_page: 1,
        total_pages: 1
      },
      content_type: 'application/json',
      status: 200
    }
    expect(actual).to eq(expected)
  end
  # it 'renders default csv response' do
  #   actual = Backframe::Response.index(@posts, { format: 'csv' })
  #   expected = {
  #     text: "id,title,body,author.id,author.name\n1,Post 1,<p>This is a post</p>,1,Greg Kops\n2,Post 2,<p>This is a another post</p>,1,Greg Kops\n3,Post 3,<p>This is a another post</p>,1,Greg Kops",
  #     content_type: "text/plain",
  #     status: 200
  #   }
  #   expect(actual).to eq(expected)
  # end

end
