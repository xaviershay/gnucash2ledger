require 'spec'
require File.dirname(__FILE__) + '/../lib/parser'

describe G2L::Input do
  it 'does stuff' do
    #input = File.open("spec/fixtures/money.xml").read
    #puts G2L::Input.new(input).to_ledger
  end

  it 'parses regular transactions' do
    input = File.open("spec/fixtures/plain_transaction.xml").read
    output = G2L::Input.new(input).to_ledger
    with_entry(output, "Plain Transaction") do |entry|
      entry.should have_transaction("Equity:Opening Balances", -100)
      entry.should have_transaction("Assets", 100)
    end
  end

  def with_entry(output, desc)
    entry = output.split("\n\n").detect {|x| x =~ /#{desc}/ }
    entry.should_not be_nil
    yield(entry)
  end
end

Spec::Matchers.define :have_transaction do |desc, amount|
  match do |actual|
    parse_transactions(actual).detect {|tx|
      tx[0] == desc && tx[1].to_f == amount
    }
  end

  failure_message_for_should do |actual|
    "\nTransaction matching (#{desc}, #{amount}) not found in:\n" + actual + "\n"
  end

  def parse_transactions(input)
    txs = actual.lines.to_a[1..-1].map {|x| x.match(/  (.*?)\s+\$(-?\d+\.\d+)/).captures }
  end
end
