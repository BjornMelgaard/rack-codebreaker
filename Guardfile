guard :rack, port: 9292 do
  watch('Gemfile.lock')
  watch(%r{^(app)/.*.rb})
end

guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }
end

# group :specs, halt_on_fail: true do