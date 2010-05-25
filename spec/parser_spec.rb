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
    with_entry(output,
      :description => "Plain Transaction",
      :date        => Date.new(2010, 5, 8),
      :reconciled  => false
    ) do |entry|
      entry.should have_transaction("Equity:Opening Balances", -100)
      entry.should have_transaction("Assets", 100)
    end
  end

  it 'parses reconciled transactions' do
    input = File.open("spec/fixtures/reconciled_transaction.xml").read
    output = G2L::Input.new(input).to_ledger
    with_entry(output,
      :description => "Reconciled Transaction",
      :date        => Date.new(2010, 5, 8),
      :reconciled  => true
    ) do |entry|
      entry.should have_transaction("Equity:Opening Balances", -100)
      entry.should have_transaction("Assets", 100)
    end
  end

  def with_entry(output, opts)
    entries = parse_entries(output)
    entry = entries.detect {|x|
      ret = true
      ret &&= x[:header][0] == opts[:date].strftime("%Y/%m/%d") if opts[:date]
      ret &&= ((x[:header][1] == '*') == opts[:reconciled]) if opts[:reconciled]
      ret &&= x[:header][2] == opts[:description] if opts[:description]
    }
    if entry.nil?
      opts = opts.merge(:date => opts[:date].to_s) if opts[:date]
      fail "\nCould not locate entry matching #{opts.inspect} in:\n" + output + "\n"
    end
    yield(entry[:raw])
  end

  def parse_entries(output)
    output.split("\n\n").map {|x| {
      :header => x.lines.to_a[0].match(/([^\s]*)\s(?:(\*)\s)?(.*)/).captures,
      :raw    => output
    }}
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
