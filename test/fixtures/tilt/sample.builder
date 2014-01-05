xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.my_elements do |e|
  xml.myitem {|element| element.my_element_name('element_value')}
end
