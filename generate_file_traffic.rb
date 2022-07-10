#!/usr/bin/env ruby

#gem 'parallel'
#gem 'down'
require 'parallel'
require 'down'
require 'uri'

#intensity_size = 400 ; system('ulimit -n 10000' ) #Need root
#intensity_size = 1000
#intensity_size = 100
intensity_size = 40
arr_numbers = Array(1...intensity_size)
url_list = [
  #'https://secure.eicar.org/eicar.com',
  #'https://secure.eicar.org/eicar.com.txt',
  #'https://secure.eicar.org/eicar_com.zip',
  #'https://secure.eicar.org/eicarcom2.zip',
  #'https://wildfire.paloaltonetworks.com/publicapi/test/pe',
  #'https://wildfire.paloaltonetworks.com/publicapi/test/elf',
  'https://file-examples.com/wp-content/uploads/2017/02/file_example_JSON_1kb.json',
  'https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data-HTML-1.23-KB-1.html',
  'https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data-HTML-1.95-KB-1.html',
  'https://file-examples.com/wp-content/uploads/2017/02/file_example_CSV_5000.csv'
]

def download_file( idx, url )
  uri = URI.parse(url)
  filename = "#{File.basename(uri.path)}.#{idx}"
  #sleep 5 ; puts "#{filename}" ; return
  #Down.download(url, destination: "./deleteme/#{filename}")
  Down.download(url, destination: File::NULL)
end

main_function = proc do |idx, list| 
  #Parallel.map(list, in_processes: list.size) { |url|
  #Parallel.map(list, in_threads: list.size) { |url|
  #Parallel.map(list, in_threads: list.size) { |url|
  Parallel.map(list, in_processes: list.size) { |url|
    1.upto(10000) { |itr|
       download_file("#{idx}-#{itr}", url)
       ####puts "[#{Time.now}][idx #{idx}][itr #{itr}][url #{url}]"
    }
  }
end

generate_process_traffic = proc do 
  Parallel.map(arr_numbers, in_threads: arr_numbers.size) { |arr_idx|
    main_function.call arr_idx, url_list
  }
end

puts "Start time is #{Time.now}\n\r"
system "mkdir ./deleteme"
generate_process_traffic.call
puts "Complete time is #{Time.now}\n\r"


