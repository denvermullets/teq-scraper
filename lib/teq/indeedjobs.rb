require 'kimurai'
require 'json'
# this loads each url from the JSON file and pulls the description,
# removes all punctuation and converts it all to lowercase
# then, throw each word into a hash for JSON
class TequilaScraper < Kimurai::Base
  @name = 'jane-warn'
  @start_urls = JSON.parse(File.read('tmp/210102_indeed_jobs_urls.json'))
  # @start_urls = ['https://indeed.com/rc/clk?jk=d58c7c483dd67ba9&fccid=068406d6c4205250&vjs=3']
  @engine = :selenium_chrome

  @@tequilas = []
  @@word_count = {}

  def scrape_page
    skip_list = JSON.parse(File.read('tmp/210102_skip_list.json'))
    sleep 3.5
    doc = browser.current_response
    # job_desc = doc.css('div.jobsearch-jobDescriptionText').text.gsub(/[[:punct:]]/, ' ').downcase
    job_desc = doc.css('div.jobsearch-jobDescriptionText').text.downcase.gsub(/[^a-z\s]/i, ' ')
    job_array = job_desc.split(' ')
    job_array.each do |word|
      if skip_list.include? word
        puts "skip word: #{word}"
      else
        @@word_count[word] ? @@word_count[word] += 1 : @@word_count[word] = 1
      end
    end

    puts @@word_count
  end

  def parse(response, url:, data: {})
    scrape_page

    sorted_hash = @@word_count.sort_by {|a,b| -b}
    sorted_hashery = sorted_hash.to_h

    File.open("tmp/210102_sorted_skills.json","w") do |f|
      f.write(JSON.pretty_generate(sorted_hashery))
    end
  end
end

TequilaScraper.crawl!
puts 'done scraping'
