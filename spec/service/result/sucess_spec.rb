require 'spec_helper'

describe Backframe::Service::Result::Success do

  it 'reports success' do
    records = Backframe::Service::Result::Success.new({})
    expect(records.success?).to be true
  end

  it 'provides access to value object' do
    records = Backframe::Service::Result::Success.new({ one: 1, two: 2, three: 3 })
    expect(records.one).to eq(1)
    expect(records.two).to eq(2)
    expect(records.three).to eq(3)
  end

end
