Before do
  FileUtils.rm_rf(TEST_DIR)
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

World(Test::Unit::Assertions)

Given /^I have a blank site in "(.*)"$/ do |path|
  FileUtils.mkdir_p(path)
end

Given /^I do not have a "(.*)" directory$/ do |path|
  File.directory?("#{TEST_DIR}/#{path}")
end

# Like "I have a foo file" but gives a yaml front matter so jekyll actually processes it
Given /^I have an? "(.*)" page(?: with (.*) "(.*)")? that contains "(.*)"$/ do |file, key, value, text|
  File.open(file, 'w') do |f|
    f.write <<EOF
---
#{key || 'layout'}: #{value || 'nil'}
---
#{text}
EOF
  end
end

Given /^I have an? "(.*)" file that contains "(.*)"$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? (.*) (layout|theme) that contains "(.*)"$/ do |name, type, text|
  folder = if type == 'layout'
    '_layouts'
  else
    '_theme'
  end
  destination_file = File.join(folder, name + '.html')
  destination_path = File.dirname(destination_file)
  unless File.exist?(destination_path)
    FileUtils.mkdir_p(destination_path)
  end
  File.open(destination_file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? "(.*)" file with content:$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
  end
end

Given /^I have an? (.*) directory$/ do |dir|
  FileUtils.mkdir_p(dir)
end

Given /^I have the following (draft|post)s?(?: (in|under) "([^"]+)")?:$/ do |status, direction, folder, table|
  table.hashes.each do |post|
    title = slug(post['title'])
    ext = post['type'] || 'textile'
    before, after = location(folder, direction)

    if "draft" == status
      folder_post = '_drafts'
      filename = "#{title}.#{ext}"
    elsif "post" == status
      parsed_date = Time.xmlschema(post['date']) rescue Time.parse(post['date'])
      folder_post = '_posts'
      filename = "#{parsed_date.strftime('%Y-%m-%d')}-#{title}.#{ext}"
    end

    path = File.join(before, folder_post, after, filename)

    matter_hash = {}
    %w(title layout tag tags category categories published author path date permalink).each do |key|
      matter_hash[key] = post[key] if post[key]
    end
    matter = matter_hash.map { |k, v| "#{k}: #{v}\n" }.join.chomp

    content = if post['input'] && post['filter']
      "{{ #{post['input']} | #{post['filter']} }}"
    else
      post['content']
    end

    File.open(path, 'w') do |f|
      f.write <<EOF
---
#{matter}
---
#{content}
EOF
    end
  end
end

Given /^I have a configuration file with "(.*)" set to "(.*)"$/ do |key, value|
  File.open('_config.yml', 'w') do |f|
    f.write("#{key}: #{value}\n")
  end
end

Given /^I have a configuration file with:$/ do |table|
  File.open('_config.yml', 'w') do |f|
    table.hashes.each do |row|
      f.write("#{row["key"]}: #{row["value"]}\n")
    end
  end
end

Given /^I have a configuration file with "([^\"]*)" set to:$/ do |key, table|
  File.open('_config.yml', 'w') do |f|
    f.write("#{key}:\n")
    table.hashes.each do |row|
      f.write("- #{row["value"]}\n")
    end
  end
end


When /^I run jekyll$/ do
  run_jekyll
end

When /^I run jekyll with drafts$/ do
  run_jekyll(:drafts => true)
end

When /^I call jekyll new with test_blank --blank$/ do
  call_jekyll_new(:path => "test_blank", :blank => true)
end

When /^I debug jekyll$/ do
  run_jekyll(:debug => true)
end

When /^I change "(.*)" to contain "(.*)"$/ do |file, text|
  File.open(file, 'a') do |f|
    f.write(text)
  end
end

When /^I delete the file "(.*)"$/ do |file|
  File.delete(file)
end

Then /^the (.*) directory should +exist$/ do |dir|
  assert File.directory?(dir), "The directory \"#{dir}\" does not exist"
end

Then /^the (.*) directory should not exist$/ do |dir|
  assert !File.directory?(dir), "The directory \"#{dir}\" exists"
end

Then /^I should see "(.*)" in "(.*)"$/ do |text, file|
  assert Regexp.new(text).match(File.open(file).readlines.join)
end

Then /^I should see exactly "(.*)" in "(.*)"$/ do |text, file|
  assert_equal text, File.open(file).readlines.join.strip
end

Then /^I should not see "(.*)" in "(.*)"$/ do |text, file|
  assert_no_match Regexp.new(text), File.read(file)
end

Then /^I should see escaped "(.*)" in "(.*)"$/ do |text, file|
  assert Regexp.new(Regexp.escape(text)).match(File.open(file).readlines.join)
end

Then /^the "(.*)" file should +exist$/ do |file|
  assert File.file?(file), "The file \"#{file}\" does not exist"
end

Then /^the "(.*)" file should not exist$/ do |file|
  assert !File.exists?(file), "The file \"#{file}\" exists"
end

Then /^I should see today's time in "(.*)"$/ do |file|
  assert_match Regexp.new(Regexp.escape(Time.now.to_s)), File.open(file).readlines.join
end

Then /^I should see today's date in "(.*)"$/ do |file|
  assert_match Regexp.new(Date.today.to_s), File.open(file).readlines.join
end
