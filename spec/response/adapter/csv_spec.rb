require 'spec_helper'

describe Backframe::Response::Adapter::Csv do

  it 'renders full payload' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Csv.render(collection, fields)
    expected = [
      'id,first_name,last_name,email,photo.id,photo.path',
      '1,Greg,Kops,greg@thinktopography.com,1,/images/greg.jpg',
      '2,Megan,Pugh,megan@thinktopography.com,2,/images/megan.jpg',
      '3,Kath,Tibbetts,kath@thinktopography.com,3,/images/kath.jpg',
      '4,Armand,Zerilli,armand@thinktopography.com,4,/images/armand.jpg'
    ].join("\n")
    expect(actual).to eq(expected)
  end

  it 'renders with a single simple key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'first_name')
    actual = Backframe::Response::Adapter::Csv.render(collection, fields)
    expected = ['first_name','Greg','Megan','Kath','Armand'].join("\n")
    expect(actual).to eq(expected)
  end

  it 'renders with a single nested key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'photo.id')
    actual = Backframe::Response::Adapter::Csv.render(collection, fields)
    expected = ['photo.id','1','2','3','4'].join("\n")
    expect(actual).to eq(expected)
  end

  it 'renders with pagination' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, 1, 2)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Csv.render(collection, fields)
    expected = [
      'id,first_name,last_name,email,photo.id,photo.path',
      '1,Greg,Kops,greg@thinktopography.com,1,/images/greg.jpg',
      '2,Megan,Pugh,megan@thinktopography.com,2,/images/megan.jpg'
    ].join("\n")
    expect(actual).to eq(expected)
  end

end
