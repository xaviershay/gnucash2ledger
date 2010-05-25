require 'spec_helper'

describe G2L::Input do
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

  it 'parses commodities' do
    input = File.open("spec/fixtures/commodities.xml").read
    output = G2L::Input.new(input).to_ledger
    with_entry(output,
      :description => "Share purchase",
      :date        => Date.new(2010, 4, 25)
    ) do |entry|
      entry.should have_transaction("Equity", -1209.60)
      entry.should have_transaction("Brokerage", "120 BEN")
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
