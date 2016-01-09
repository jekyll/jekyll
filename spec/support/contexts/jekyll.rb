#!/usr/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

shared_context :jekyll do
  let :mocked_jekyll do
    Mocks::Jekyll.new \
      self
  end

  after do
    mocked_jekyll.teardown
  end
end
