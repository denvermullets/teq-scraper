require 'kimurai'
require "selenium-webdriver"
require 'dotenv/load'

class Indeed < Kimurai::Base
  @name = 'eng_job_scraper_student'
  @start_urls = [
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY', 
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=10', 
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=20',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=30',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=40',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=50',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=60',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=70',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=80',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=90',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=100',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=110',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=120',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=130',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=140',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=150',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=160',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=170',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=180',
    'https://www.indeed.com/jobs?q=full%20stack%20developer&l=New%20York%2C%20NY&start=190',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY', 
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=10', 
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=20',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=30',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=40',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=50',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=60',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=70',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=80',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=90',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=100',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=110',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=120',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=130',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=140',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=150',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=160',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=170',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=180',
    'https://www.indeed.com/jobs?q=software%20engineer&l=New%20York%2C%20NY&start=190',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY', 
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=10', 
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=20',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=30',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=40',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=50',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=60',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=70',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=80',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=90',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=100',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=110',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=120',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=130',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=140',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=150',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=160',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=170',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=180',
    'https://www.indeed.com/jobs?q=software%20developer&l=New%20York%2C%20NY&start=190',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY', 
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=10', 
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=20',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=30',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=40',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=50',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=60',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=70',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=80',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=90',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=100',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=110',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=120',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=130',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=140',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=150',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=160',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=170',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=180',
    'https://www.indeed.com/jobs?q=front%20end%20developer&l=New%20York%2C%20NY&start=190',
    
  ]
  @engine = :selenium_chrome
  @@jobs = []

  def scrape_page
    # Update response to current response after interaction with a browser
    doc = browser.current_response
    # browser.save_screenshot
    sleep 2

    while (doc.css('div.jobsearch-SerpJobCard')[0]) do
      # this loop goes thru the however many job listings are on the page
      doc = browser.current_response
      # get first job listing
      single_job = doc.css('div.jobsearch-SerpJobCard')[0]
      # get job information
      job_url = single_job.css('a.jobtitle').attribute('href')
      job_url = 'https://indeed.com' + job_url
      
      puts ' ===== '
      puts job_url
      puts " ===== "
      
      @@jobs << job_url if !@@jobs.include?(job_url)
      # we want to delete the LI so that the dom will render the next job (only shows 7 until scroll)
      doc.css('div.jobsearch-SerpJobCard')[0].remove
      browser.execute_script("document.querySelector('div.jobsearch-SerpJobCard').remove()") 
      sleep 0.1
    
    end
  end
    

  def parse(response, url:, data: {})

    scrape_page

    File.open("tmp/indeed_jobs_urls.json","w") do |f|
      f.write(JSON.pretty_generate(@@jobs))
    end
      
    @@jobs
  end
end

Indeed.crawl!
