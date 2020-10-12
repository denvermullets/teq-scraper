require 'kimurai'
require "selenium-webdriver"
require 'dotenv/load'

class JobScraper < Kimurai::Base
  @name= 'eng_job_scraper'
  @start_urls = ["https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area"]
  # @start_urls = ["https://www.linkedin.com/jobs/"]
  @engine = :selenium_chrome

  @@jobs = []

  def scrape_page
    username = ENV['EMAIL']
    password = ENV['PASSWORD']
    sleep 5
    browser.find(:css, 'a.nav__button-secondary').click
    sleep 1
    browser.fill_in 'session_key', with: username
    sleep 1
    browser.fill_in 'session_password', with: password
    sleep 3
    browser.find(:css, 'button.btn__primary--large').click
    
    
    # Update response to current response after interaction with a browser
    # browser.window.resize_to(4000,4000)
    # browser.manage.window.resize_to(4000,4000)
    doc = browser.current_response
    # doc.manage.window.resize_to(4000, 4000)
    browser.save_screenshot
    # Collect results
    job_listings = doc.css('ul.jobs-search-results__list')
    # sleep 5
    # puts job_listings
    # browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    # browser.execute_script "window.scrollBy(1200,1400)"
    sleep 2
    browser.send_keys [:command, :subtract]
    job_listings.css('li.jobs-search-results__list-item').each do |single_job|
      # single_job.click_on(:css, 'a.job-card-list__title')
      # sleep 2

      job_url = single_job.css('a.job-card-list__title').attribute('href')
      puts "job url - #{job_url}"
      # puts single_job

    end


    # results = response.xpath("//div[@class='g']//h3/a").map do |a|
    #   { title: a.text, url: a[:href] }
    # end
    # puts results
    # doc = browser.current_response

  end

  def parse(response, url:, data: {})

    scrape_page
      
  end
end

JobScraper.crawl!
