require 'spec'
require File.dirname(__FILE__) + '/../lib/parser'

Spec::Matchers.define :have_transaction do |desc, amount|
  match do |actual|
    parse_transactions(actual).detect {|tx|
      tx[1] = tx[1][1..-1].to_f if tx[1].starts_with?('$')
      tx[0] == desc && tx[1] == amount
    }
  end

  failure_message_for_should do |actual|
    "\nTransaction matching (#{desc}, #{amount}) not found in:\n" + actual + "\n"
  end

  def parse_transactions(input)
    txs = actual.lines.to_a[1..-1].map {|x| x.match(/  (.*?)\s{5,}(.*)/).try(:captures) || [] }
  end
end
