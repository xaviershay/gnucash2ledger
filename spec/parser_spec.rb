require 'spec'
require File.dirname(__FILE__) + '/../lib/parser'

describe G2L::Input do
  it 'does stuff' do
    input = File.open("spec/fixtures/money.xml").read
    puts G2L::Input.new(input).to_ledger
  end
end
