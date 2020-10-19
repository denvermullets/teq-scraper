require 'kimurai'
require 'json'

class TequilaScraper < Kimurai::Base
  @name = 'tqdb_scrap'
  @start_urls = JSON.parse(File.read("tmp/indeed_jobs_urls.json"))
  # @start_urls = ['https://indeed.com/rc/clk?jk=d58c7c483dd67ba9&fccid=068406d6c4205250&vjs=3']
  @engine = :selenium_chrome
  
  @@tequilas = []
  @@word_count = {}

  def scrape_page
    sleep 2
    doc = browser.current_response
    job_desc = doc.css('div.jobsearch-jobDescriptionText').text.gsub(/[[:punct:]]/, '')
    # puts job_desc
    job_array = job_desc.split(' ')
    job_array.each do |word|
      @@word_count[word] ? @@word_count[word] += 1 : @@word_count[word] = 1
    end

    puts @@word_count
    
  end

  def parse(response, url:, data: {})

    scrape_page

    File.open("tmp/skills.json","w") do |f|
      f.write(JSON.pretty_generate(@@word_count))
    end

  end
end

TequilaScraper.crawl!
puts 'done scraping'