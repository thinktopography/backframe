require 'spec_helper'

describe Backframe::Service do

  it 'succeeds' do
    result = Backframe::Fixtures::CreateContactService.perform({ first_name: 'Joe', last_name: 'Doe', email: 'john.doe@gmail.com' })
    expect(result.success?).to be(true)
    expect(result.contact.first_name).to eq('Joe')
  end

  it 'fails' do
    result = Backframe::Fixtures::CreateContactService.perform({})
    expect(result.success?).to be(false)
  end

end
