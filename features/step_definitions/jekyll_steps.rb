Before do
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end

Given /^I have an "(.*)" page(?: with layout "(.*)")? that contains "(.*)"$/ do |file, layout, text|
  File.open(file, 'w') do |f|
    f.write <<EOF
---
layout: #{layout || 'nil'}
---
EOF

    f.write(text)
    f.close
  end
end

Given /^I have an "(.*)" file that contains "(.*)"$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
    f.close
  end
end

Given /^I have a (.*) layout that contains "(.*)"$/ do |layout, text|
  File.open(File.join('_layouts', layout + '.html'), 'w') do |f|
    f.write(text)
    f.close
  end
end

Given /^I have a (.*) directory$/ do |dir|
  FileUtils.mkdir(dir)
end

Given /^I have the following posts?(?: in "(.*)")?:$/ do |dir, table|
  table.hashes.each do |post|
    date = Date.parse(post['date']).strftime('%Y-%m-%d')
    path = File.join("_posts", "#{date}-#{post['title'].downcase}.textile")

    matter_hash = {'title' => post['title']}
    matter_hash['layout'] = post['layout'] if post['layout']
    matter = matter_hash.map { |k, v| "#{k}: #{v}\n" } 

    File.open(path, 'w') do |f|
      f.write <<EOF
---
#{matter}
---
#{post['content']}
EOF
      f.close
    end
  end
end

Given /^I have a configuration file(?: in "(.*)")? with "(.*)" set to "(.*)"$/ do |dir, key, value|
    pending
end

When /^I run jekyll$/ do
  `#{File.join(ENV['PWD'], 'bin', 'jekyll')}`
end

When /^I change "(.*)" to contain "(.*)"$/ do |file, text|
    pending
end

When /^I go to "(.*)"$/ do |address|
    pending
end

Then /^the (.*) directory should exist$/ do |dir|
  assert File.directory?(dir)
end

Then /^I should see "(.*)" in "(.*)"$/ do |text, file|
  assert_match Regexp.new(text), File.open(file).readlines.join
end

Then /^the "(.*)" file should not exist$/ do |file|
    pending
end

