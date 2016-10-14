require 'spec_helper'

describe Backframe::Service::Result::Failure do

  it 'reports failure' do
    records = Backframe::Service::Result::Failure.new({})
    expect(records.success?).to be false
  end

  it 'provides access to value object' do
    records = Backframe::Service::Result::Failure.new(message: 'There was a problem', errors: {})
    expect(records.message).to eq('There was a problem')
    expect(records.errors).to eq({})
  end

end
