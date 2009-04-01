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
    title = post['title'].downcase.gsub(/[^\w]/, " ").strip.gsub(/\s+/, '-')
    path = File.join(dir || '', '_posts', "#{date}-#{title}.#{post['type'] || 'textile'}")

    matter_hash = {}
    %w(title layout tags).each do |key|
      matter_hash[key] = post[key] if post[key]
    end
    matter = matter_hash.map { |k, v| "#{k}: #{v}\n" }.join.chomp

    content = post['content']
    if post['input'] && post['filter']
      content = "{{ #{post['input']} | #{post['filter']} }}"
    end

    File.open(path, 'w') do |f|
      f.write <<EOF
---
#{matter}
---
#{content}
EOF
      f.close
    end
  end
end

Given /^I have a configuration file(?: in "(.*)")? with "(.*)" set to "(.*)"$/ do |dir, key, value|
    pending
end

When /^I run jekyll$/ do
  system File.join(ENV['PWD'], 'bin', 'jekyll') + " >> /dev/null"
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

Then /^I should see today's date in "(.*)"$/ do |file|
  assert_match Regexp.new(Date.today.to_s), File.open(file).readlines.join
end

