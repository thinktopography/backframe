require 'spec_helper'

describe Backframe::Response::Adapter::Xlsx do

  it 'renders full payload' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Xlsx.render(collection, fields)
    File.open('tmp.xlsx', 'w') { |file| file.write(actual) }
    xlsx = Roo::Excelx.new('tmp.xlsx')
    expect(xlsx.sheet(0).row(1)).to eq(["id", "first_name", "last_name", "email", "photo.id", "photo.path"])
    expect(xlsx.sheet(0).row(2)).to eq(["1", "Greg", "Kops", "greg@thinktopography.com", "1", "/images/greg.jpg"])
    expect(xlsx.sheet(0).row(3)).to eq(["2", "Megan", "Pugh", "megan@thinktopography.com", "2", "/images/megan.jpg"])
    expect(xlsx.sheet(0).row(4)).to eq(["3", "Kath", "Tibbetts", "kath@thinktopography.com", "3", "/images/kath.jpg"])
    expect(xlsx.sheet(0).row(5)).to eq(["4", "Armand", "Zerilli", "armand@thinktopography.com", "4", "/images/armand.jpg"])
    File.unlink('tmp.xlsx')
  end

  it 'renders with a single simple key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'first_name')
    actual = Backframe::Response::Adapter::Xlsx.render(collection, fields)
    File.open('tmp.xlsx', 'w') { |file| file.write(actual) }
    xlsx = Roo::Excelx.new('tmp.xlsx')
    expect(xlsx.sheet(0).row(1)).to eq(["first_name"])
    expect(xlsx.sheet(0).row(2)).to eq(["Greg"])
    expect(xlsx.sheet(0).row(3)).to eq(["Megan"])
    expect(xlsx.sheet(0).row(4)).to eq(["Kath"])
    expect(xlsx.sheet(0).row(5)).to eq(["Armand"])
    File.unlink('tmp.xlsx')
  end

  it 'renders with a single nested key' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, nil, nil)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, 'photo.id')
    actual = Backframe::Response::Adapter::Xlsx.render(collection, fields)
    File.open('tmp.xlsx', 'w') { |file| file.write(actual) }
    xlsx = Roo::Excelx.new('tmp.xlsx')
    expect(xlsx.sheet(0).row(1)).to eq(["photo.id"])
    expect(xlsx.sheet(0).row(2)).to eq(["1"])
    expect(xlsx.sheet(0).row(3)).to eq(["2"])
    expect(xlsx.sheet(0).row(4)).to eq(["3"])
    expect(xlsx.sheet(0).row(5)).to eq(["4"])
    File.unlink('tmp.xlsx')
  end

  it 'renders with pagination' do
    collection = Backframe::Response::Collection.new(Backframe::Fixtures::Contact, 1, 2)
    fields = Backframe::Response::Fields.new(Backframe::Fixtures::Contact, nil)
    actual = Backframe::Response::Adapter::Xlsx.render(collection, fields)
    File.open('tmp.xlsx', 'w') { |file| file.write(actual) }
    xlsx = Roo::Excelx.new('tmp.xlsx')
    expect(xlsx.sheet(0).row(1)).to eq(["id", "first_name", "last_name", "email", "photo.id", "photo.path"])
    expect(xlsx.sheet(0).row(2)).to eq(["1", "Greg", "Kops", "greg@thinktopography.com", "1", "/images/greg.jpg"])
    expect(xlsx.sheet(0).row(3)).to eq(["2", "Megan", "Pugh", "megan@thinktopography.com", "2", "/images/megan.jpg"])
    File.unlink('tmp.xlsx')
  end

end
