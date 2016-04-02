require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/test/'
  add_filter '/features/'
  add_filter '/autotest/'

  add_group 'Binaries', '/bin/'
  add_group 'Libraries', '/lib/'
end
