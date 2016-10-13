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

  it 'handles success' do
    actual = Backframe::Response.success({ text: 'test', content_type: 'text/plain' })
    expected = { text: 'test', content_type: 'text/plain', status: 200 }
    expect(actual).to eq(expected)
  end

  it 'handles failure' do
    actual = Backframe::Response.failure('Application Error', 500)
    expected = {
      json: {
        error: {
          message: 'Application Error',
          status: 500
        }
      },
      content_type: 'application/json',
      status: 500
    }
    expect(actual).to eq(expected)
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

  it 'renders default xml response' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'xml' })
    expected = {
      xml: [
        '<?xml version="1.0"?><records>',
        '<record><id>1</id><first_name>Greg</first_name><last_name>Kops</last_name><email>greg@thinktopography.com</email><photo.id>1</photo.id><photo.path>/images/greg.jpg</photo.path></record>',
        '<record><id>2</id><first_name>Megan</first_name><last_name>Pugh</last_name><email>megan@thinktopography.com</email><photo.id>2</photo.id><photo.path>/images/megan.jpg</photo.path></record>',
        '<record><id>3</id><first_name>Kath</first_name><last_name>Tibbetts</last_name><email>kath@thinktopography.com</email><photo.id>3</photo.id><photo.path>/images/kath.jpg</photo.path></record>',
        '<record><id>4</id><first_name>Armand</first_name><last_name>Zerilli</last_name><email>armand@thinktopography.com</email><photo.id>4</photo.id><photo.path>/images/armand.jpg</photo.path></record>',
        '</records>'
      ].join,
      content_type: "application/xhtml+xml",
      status: 200
    }
    expect(actual).to eq(expected)
  end

  it 'renders default csv response' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'csv' })
    expected = {
      text: [
        'id,first_name,last_name,email,photo.id,photo.path',
        '1,Greg,Kops,greg@thinktopography.com,1,/images/greg.jpg',
        '2,Megan,Pugh,megan@thinktopography.com,2,/images/megan.jpg',
        '3,Kath,Tibbetts,kath@thinktopography.com,3,/images/kath.jpg',
        '4,Armand,Zerilli,armand@thinktopography.com,4,/images/armand.jpg'
      ].join("\n"),
      content_type: "text/plain",
      status: 200
    }
    expect(actual).to eq(expected)
  end

  it 'renders default tsv response' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'tsv' })
    expected = {
      text: [
        "id\tfirst_name\tlast_name\temail\tphoto.id\tphoto.path",
        "1\tGreg\tKops\tgreg@thinktopography.com\t1\t/images/greg.jpg",
        "2\tMegan\tPugh\tmegan@thinktopography.com\t2\t/images/megan.jpg",
        "3\tKath\tTibbetts\tkath@thinktopography.com\t3\t/images/kath.jpg",
        "4\tArmand\tZerilli\tarmand@thinktopography.com\t4\t/images/armand.jpg"
      ].join("\n"),
      content_type: "text/plain",
      status: 200
    }
    expect(actual).to eq(expected)
  end

  it 'renders default xlsx response' do
    actual = Backframe::Response.render(Backframe::Fixtures::Contact, { format: 'xlsx' })
    expect(actual[:content_type]).to eq('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    expect(actual[:status]).to eq(200)
    File.open('tmp.xlsx', 'w') { |file| file.write(actual[:text]) }
    xlsx = Roo::Excelx.new('tmp.xlsx')
    expect(xlsx.sheet(0).row(1)).to eq(["id", "first_name", "last_name", "email", "photo.id", "photo.path"])
    expect(xlsx.sheet(0).row(2)).to eq(["1", "Greg", "Kops", "greg@thinktopography.com", "1", "/images/greg.jpg"])
    expect(xlsx.sheet(0).row(3)).to eq(["2", "Megan", "Pugh", "megan@thinktopography.com", "2", "/images/megan.jpg"])
    expect(xlsx.sheet(0).row(4)).to eq(["3", "Kath", "Tibbetts", "kath@thinktopography.com", "3", "/images/kath.jpg"])
    expect(xlsx.sheet(0).row(5)).to eq(["4", "Armand", "Zerilli", "armand@thinktopography.com", "4", "/images/armand.jpg"])
    File.unlink('tmp.xlsx')
  end

end
