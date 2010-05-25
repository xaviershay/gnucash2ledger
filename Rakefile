require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = false
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Build the gem"
task :build do
  exec('gem build gnucash2ledger.gemspec')
end

task :default => :spec
