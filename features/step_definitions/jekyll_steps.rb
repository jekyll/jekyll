Before do
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end

Given /^I have an "(.*)" file(?: with (.*) "(.*)")? that contains "(.*)"$/ do |file, key, value, text|
  File.open(file, 'w') do |f|
    if key && value
      f.write <<EOF
---
#{key}: #{value}
---
EOF
    end

    f.write(text)
    f.close
  end
end

Given /^I have a (.*) layout that contains "(.*)"$/ do |layout, text|
  File.open(layout, 'w') do |f|
    f.write(text)
    f.close
  end
end

Given /^I have a (.*) directory$/ do |dir|
  FileUtils.mkdir(dir)
end

Given /^I have the following posts?(?: in "(.*)")?:$/ do |table, dir|
    pending
end

Given /^I have a configuration file(?: in "(.*)")? with "(.*)" set to "(.*)"$/ do |dir, key, value|
    pending
end

When /^I run jekyll$/ do
  `#{File.join(ENV['PWD'], 'bin', 'jekyll')} >> /dev/null`
end

When /^I change "(.*)" to contain "(.*)"$/ do |file, text|
    pending
end

When /^I go to "(.*)"$/ do |address|
    pending
end

Then /^the (.*) directory should exist$/ do |dir|
  pending
end

Then /^I should see "(.*)"(?: in "(.*)")?$/ do |text, file|
    pending
end

Then /^the "(.*)" file should not exist$/ do |file|
    pending
end

