require 'kimurai'
require "selenium-webdriver"
require 'dotenv/load'

class Indeed < Kimurai::Base
  @name = 'eng_job_scraper_student'
  
  # @start_urls = [
  #   "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area", 
  #   "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area&start=25", 
  #   "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area&start=50", 
  #   "https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area&start=75"
  # ]
  # @start_urls = ["https://www.linkedin.com/jobs/search/?f_TPR=r86400&geoId=90000070&keywords=full%20stack&location=New%20York%20City%20Metropolitan%20Area"]
  # no filters
  @start_urls = ["https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&fromage=1"]
  @engine = :selenium_chrome
  @@jobs = []

  def scrape_page
    # Update response to current response after interaction with a browser
    doc = browser.current_response
    browser.save_screenshot
    sleep 2
    while (doc.css('div.jobsearch-SerpJobCard')[0]) do
      # this loop goes thru the however many job listings are on the page
      doc = browser.current_response
      # get first job listing
      single_job = doc.css('div.jobsearch-SerpJobCard')[0]
      # get job information
      job_url = single_job.css('a.jobtitle').attribute('href')
      job_role = single_job.css('a.jobtitle').text.strip().gsub(/\n/, "")
      job_company_name = single_job.css('span.company').text.strip().gsub(/\n/, "")
      # single_job.css('span.location') ? job_location = single_job.css('span.location').text.strip().gsub(/\n/, "") : job_location = single_job.css('div.location').text.strip().gsub(/\n/, "")
      job_location = single_job.css('span.location') ? single_job.css('span.location').text.strip().gsub(/\n/, "") : single_job.css('div.location').text.strip().gsub(/\n/, "")
      job_salary = single_job.css('span.salaryText') ? single_job.css('span.salaryText').text.strip().gsub(/\n/, "") : ''
      job_description = single_job.css('div.summary ul li').text.strip().gsub(/\n/, "")
      puts ' ===== '
      puts job_company_name
      puts job_role
      puts job_location
      puts job_salary
      puts job_description
      puts job_url
      puts " ===== "
      job = {
        company: job_company_name, 
        role: job_role, 
        location: job_location, 
        salary_info: job_salary,
        job_description: job_description,
        posting: job_url,
      }
      @@jobs << job
      # we want to delete the LI so that the dom will render the next job (only shows 7 until scroll)
      doc.css('div.jobsearch-SerpJobCard')[0].remove
      browser.execute_script("document.querySelector('div.jobsearch-SerpJobCard').remove()") ; sleep 2
    
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

Indeed.crawl!
