require 'kimurai'
require "selenium-webdriver"

class JobScraper < Kimurai::Base
  @name= 'eng_job_scraper'
  @start_urls = ["https://www.linkedin.com/jobs/"]
  @engine = :selenium_chrome
  
  @@jobs = []

  def scrape_page

    doc = browser.current_response
        
  end

  def parse(response, url:, data: {})

    scrape_page
      
  end
end

JobScraper.crawl!
