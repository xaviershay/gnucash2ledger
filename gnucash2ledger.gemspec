require 'bundler'

Gem::Specification.new do |s|
  s.name = 'gnucash2ledger'
  s.version = '0.1'
  s.summary = 'Convert GnuCash files to a format supported by the ledger command line application'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Xavier Shay"]
  s.email       = ["contact@rhnh.net"]
  s.homepage    = "http://github.com/xaviershay/gnucash2ledger"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README CHANGELOG)
  s.executables  = ['gnucash2ledger']
  s.require_path = 'lib'
  s.add_bundler_dependencies
end
