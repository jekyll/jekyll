# frozen_string_literal: true

# ---------------------------------------------------------
# Adapted from: https://gist.github.com/palexander/8592640
# ---------------------------------------------------------

require "benchmark/ips"

NAME  = "Test Name"
EMAIL = "test@example.org"

class Person
  attr_accessor :name, :email

  def set_with_hash(options = {})
    @name  = options[:name]
    @email = options[:email]
  end

  def set_with_keywords(name:, email:)
    @name  = name
    @email = email
  end
end

Benchmark.ips do |x|
  x.report("hash arg") do
    p = Person.new
    p.set_with_hash(name: NAME, email: EMAIL)
  end

  x.report("keyword args") do
    p = Person.new
    p.set_with_keywords(name: NAME, email: EMAIL)
  end

  x.compare!
end
