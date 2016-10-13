require 'spec_helper'

describe Backframe::Response do

  before(:all) do
    @greg = Backframe::Fixtures::Author.create(name: 'Greg Kops')
    @post1 = @greg.posts.create(title: 'Post 1', body: '<p>This is a post</p>')
    @post2 = @greg.posts.create(title: 'Post 2', body: '<p>This is a another post</p>')
    @post3 = @greg.posts.create(title: 'Post 3', body: '<p>This is a another post</p>')
    @post1.comments.create(author: @greg, contents: 'boom')
    @posts = Backframe::Fixtures::Post.all
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

  it 'renders error if no format provided' do
    actual = Backframe::Response.index(@posts, { format: 'bat' })
    expected = {
      json: { error: { message: "Unknown Format", status: 404 } },
      content_type: 'application/json',
      status: 404
    }
    expect(actual).to eq(expected)
  end

  # it 'renders with json pagination' do
  #   actual = Backframe::Response.index(@posts, { page: 1, format: 'json' })
  #   expected = {
  #     json: {
  #       records: [
  #         { id: 1, title: 'Post 1', body: '<p>This is a post</p>', author_id: 1 },
  #         { id: 2, title: 'Post 2', body: '<p>This is a another post</p>', author_id: 1 },
  #         { id: 3, title: 'Post 3', body: '<p>This is a another post</p>', author_id: 1 }
  #       ],
  #       total_records: 2,
  #       current_page: 1,
  #       total_pages: 1
  #     },
  #     content_type: 'application/json',
  #     status: 200
  #   }
  #   expect(actual).to eq(expected)
  # end

end
