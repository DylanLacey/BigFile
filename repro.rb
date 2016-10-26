##Blank Selenium Test
require "selenium/webdriver"
require 'selenium/webdriver/remote/http/persistent'


def un
  ENV["SAUCE_USERNAME"]
end

def ak
  ENV["SAUCE_ACCESS_KEY"]
end

def auth
  "#{un}:#{ak}"
end

def server 
  "ondemand.saucelabs.com"
end

def port
  80
end

def endpoint
  "#{server}:#{port}/wd/hub"
end

def auth_endpoint 
  "http://#{auth}@#{endpoint}"
end

def caps
caps = Selenium::WebDriver::Remote::Capabilities.firefox()
caps['platform'] = 'Windows 7'
caps['version'] = '47.0'

return caps
end

http_client = ::Selenium::WebDriver::Remote::Http::Persistent.new
http_client.timeout = 300 # Browser launch can take a while   

driver = Selenium::WebDriver.for :remote, :url => auth_endpoint, :desired_capabilities => caps, :http_client => http_client

driver.file_detector = lambda do |args|
   # args => ["/path/to/file"]
   str = args.first.to_s    
   str if File.exist?(str)
end

driver.navigate.to "http://localhost:3000/users/new"

upload_field = driver.find_element :id, 'user_profile_image'
puts "Attaching file"
upload_field.send_keys '/Users/dylanlacey/Projects/support_projects/44269/upload_test/test.gif'
puts "File attached"
inputs = driver.find_elements :tag_name, 'input'
submission_button = nil
inputs.each do |i|
  if i[:type] == 'submit'
    submission_button = i
  end
end

submission_button.click

driver.quit 

