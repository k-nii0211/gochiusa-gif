require 'open-uri'
require 'nokogiri'
require 'fileutils'

root_url = 'http://matome.naver.jp/odai/2140517249018385501'

doc = Nokogiri::HTML(open(root_url))

local_dir = "#{File.dirname(__FILE__)}/../tmp"

FileUtils.mkdir_p(local_dir) unless File.exist?(local_dir)

doc.xpath('//*[@class="LyMain"]//p[@class="mdMTMWidget01ItemImg01View"]//a/@href').each do |node|
  img_doc = Nokogiri::HTML(open(node.value))
  img_doc.xpath('//*[@class="LyMain"]//p[@class="mdMTMEnd01Img01"]//a/@href').each do |img_node|
    img_content = open(img_node).read
    file_name = File.join(local_dir, File.basename(img_node))
    puts "Fetching #{img_node}"
    if File.exist?(file_name)
      puts "file was exists. #{file_name}"
      next
    end
    File.open(file_name, 'w') do |file|
      file.write(img_content)
    end
    puts "Success... #{file_name}"
  end

  sleep 1
end