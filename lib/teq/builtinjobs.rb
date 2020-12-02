require 'kimurai'
require 'json'

# this loads each url from the JSON file and pulls the description,
# removes all punctuation and converts it all to lowercase
# then, throw each word into a hash for JSON

class BuiltInJobs < Kimurai::Base
  @name = 'keyword_count_stu'
  @start_urls = JSON.parse(File.read("tmp/201128_builtin_jobs.json"))
  # @start_urls = ['https://www.builtinnyc.com/job/engineer/sr-full-stack-engineer-core/79411']
  @engine = :selenium_chrome
  
  @@tequilas = []
  @@word_count = {}

  def scrape_page
    sleep 2
    doc = browser.current_response
    job_desc = doc.css('div.job-description').text.gsub(/[[:punct:]]/, '').downcase
    # puts job_desc
    job_array = job_desc.split(' ')
    job_array.each do |word|
      @@word_count[word] ? @@word_count[word] += 1 : @@word_count[word] = 1
    end

    puts @@word_count
    
  end

  def parse(response, url:, data: {})

    scrape_page

    sorted_hash = @@word_count.sort_by {|a,b| -b}
    sorted_hashery = sorted_hash.to_h  

    File.open("tmp/201128_builtin_skills.json","w") do |f|
      f.write(JSON.pretty_generate(sorted_hashery))
    end

  end
end

BuiltInJobs.crawl!
puts 'done scraping'