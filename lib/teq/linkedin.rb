require 'kimurai'
require "selenium-webdriver"
require 'dotenv/load'

class Linkedin < Kimurai::Base
  @name = 'eng_job_scraper_student'
  
  @start_urls = [
    "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area", 
    "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area&start=25", 
    "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area&start=50", 
    "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area&start=75"
  ]
  # @start_urls = ["https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area"]
  # no filters
  # @start_urls = ["https://www.linkedin.com/jobs/search/?geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area"]
  @engine = :selenium_chrome
  @@jobs = []

  def scrape_page
    username = ENV['EMAIL']
    password = ENV['PASSWORD']
    sleep 5
    # see if we're logged in or not
    begin
      browser.find(:css, 'a.nav__button-secondary').click
      sleep 1
      browser.fill_in 'session_key', with: username
      sleep 1
      browser.fill_in 'session_password', with: password
      sleep 3
      browser.find(:css, 'button.btn__primary--large').click
    rescue Capybara::ElementNotFound
      puts "user is logged in"
    end
    
    # Update response to current response after interaction with a browser
    doc = browser.current_response
    browser.save_screenshot
    sleep 2
    
    while (doc.css('li.jobs-search-results__list-item')[0]) do
      # this loop goes thru the 25 job listings per page
      doc = browser.current_response
      # get div of all job listings, sometimes behaves weird if i don't snag a lower parent node
      job_listings = doc.css('ul.jobs-search-results__list')
      # get first job listing
      single_job = job_listings.css('li.jobs-search-results__list-item')[0]
      # get job information
      job_url = single_job.css('a.job-card-list__title').attribute('href')
      job_role = single_job.css('a.job-card-list__title').text.gsub(/\n/, "").strip().gsub(/\n/, "")
      job_company_name = single_job.css('a.job-card-container__company-name').text.strip().gsub(/\n/, "")
      job_company_url = single_job.css('a.job-card-container__company-name').attribute('href')
      job_location = single_job.css('li.job-card-container__metadata-item').text.strip().gsub(/\n/, "")
      job_network = single_job.css('div.job-flavors__label').text.strip().gsub(/\n/, "")
      # we want to delete the LI so that the dom will render the next job (only shows 7 until scroll)
      job_listings.css('li.jobs-search-results__list-item')[0].remove
      browser.execute_script("document.querySelector('li.jobs-search-results__list-item').remove()") ; sleep 2
      puts ' ===== '
      puts job_company_name
      puts job_role
      puts job_location
      puts job_network
      puts job_company_url
      puts job_url
      puts " ===== "
      browser.save_screenshot
      sleep 5
      job = {company: job_company_name, role: job_role, location: job_location, network: job_network, company_url: job_company_url, posting: job_url}
      @@jobs << job
    end
  end

  def parse(response, url:, data: {})

    scrape_page

    File.open("tmp/jobs.json","w") do |f|
      f.write(JSON.pretty_generate(@@jobs))
    end
      
    @@jobs
  end
end

Linkedin.crawl!
