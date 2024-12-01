require 'net/http'
require 'uri'

day_num = ARGV[0]

dir_name = "day_#{day_num}"
raise "Day already exists" if File.directory?(dir_name)

system("mkdir #{dir_name}")
system("touch #{dir_name}/day_#{day_num}.rb")

url = URI.parse("https://adventofcode.com/2024/day/#{day_num}/input")
session_cookie = ENV["AOC_SESSION_COOKIE"]

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true if url.scheme == 'https'

request = Net::HTTP::Get.new(url)
request['Cookie'] = "session=#{session_cookie}"

response = http.request(request)

if response.is_a?(Net::HTTPSuccess)
  File.open("#{dir_name}/input.txt", 'w') do |file|
    file.write(response.body)
  end
else
  raise "HTTP Error: #{response.code} - #{response.message}"
end

