require 'kimurai'
require 'pry'

# JobScraper is just a demo to scrape the listings from an Indeed search
class JobScraper < Kimurai::Base
  attr_accessor :jobs

  @name = 'eng_job_scraper'
  @start_urls = ['https://www.indeed.com/jobs?q=software+engineer&l=New+York%2C+NY']
  @engine = :selenium_chrome

  def self.jobs
    []
  end

  def scrape_page
    doc = browser.current_response
    returned_jobs = doc.css('td#resultsCol')

    returned_jobs.css('div.jobsearch-SerpJobCard').each do |char_element|
      # binding.pry # this is currently not storing the array, feel like i'm missing an obvious thing - i'll come back
      JobScraper.jobs << job_info(char_element)
    end
  end

  def job_info(char_element)
    {
      title: char_element.css('h2 a')[0].attributes['title'].value.gsub(/\n/, ''),
      link: "https://indeed.com#{char_element.css('h2 a')[0].attributes['href'].value.gsub(/\n/, '')}",
      description: char_element.css('div.summary').text.gsub(/\n/, ''),
      company: char_element.css('span.company').text.gsub(/\n/, ''),
      location: char_element.css('div.location').text.gsub(/\n/, ''),
      salary: char_element.css('div.salarySnippet').text.gsub(/\n/, ''),
      requirements: char_element.css('div.jobCardReqContainer').text.gsub(/\n/, '')
    }
  end

  def parse(response, url:, data: {})
    scrape_page
    puts "🔹 🔹 🔹 CURRENT NUMBER OF JOBS: #{JobScraper.jobs.count}🔹 🔹 🔹"

    File.open('tmp/jobs.json', 'w') do |f|
      f.write(JSON.pretty_generate(JobScraper.jobs))
    end
  end
end

JobScraper.crawl!
