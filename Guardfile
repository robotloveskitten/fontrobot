# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork' do
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', :cli => '--color --drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/fontrobot/(.+)\.rb$})    { |m| "spec/fontrobot/#{m[1]}_spec.rb" }
  watch('lib/fontrobot.rb')              { 'spec/fontrobot/fontrobot_spec.rb' }
  watch('lib/fontrobot/core.rb')         { 'spec/fontrobot/fontrobot_spec.rb' }
  watch('spec/spec_helper.rb')            { 'spec' }
end
