require 'kimurai'
require "selenium-webdriver"
require 'dotenv/load'

class Indeed < Kimurai::Base
  @name = 'eng_job_scraper_student'
  @start_urls = ["https://www.builtinnyc.com/jobs/new-york-city/dev-engineering?page=1"]
  @engine = :selenium_chrome
  @@jobs = []

  def scrape_page
    sleep 3 #let vue page load
    doc = browser.current_response
    browser.save_screenshot

    while (doc.css('div.job-item')[0]) do
      doc = browser.current_response
      single_job = doc.css('div.job-item')[0]
      job_url = single_job.css('a.job-row').attribute('href')
      job_role = single_job.css('h2.job-title')[0].text.strip().gsub(/\n/, "")
      job_company_name = single_job.css('div.company-title span')[0].text.strip().gsub(/\n/, "")
      job_description = single_job.css('div.job-description').text.strip().gsub(/\n/, "")
      job_location = "Greater NYC area"

      puts ' ===== '
      puts job_company_name
      puts job_role
      puts job_location
      # puts job_salary
      puts job_description
      puts job_url
      puts " ===== "
      job = {
        company: job_company_name, 
        role: job_role, 
        location: job_location, 
        # salary_info: job_salary,
        job_description: job_description,
        posting: job_url,
      }
      @@jobs << job

      # check to see if there are more jobs hidden -
      # if single_job.css('div.mb-2')[0]
      #   puts 'found hidden jobs'
      #   puts '*****************************************'
      #   puts doc.css('div.job-item')[0].css('div.mt-2')
      #   puts '*****************************************'
      #   browser.execute_script("document.querySelector('div.load-more-button').click()") 
      #   puts 'loaded hidden jobs, maybe'
        
      #   while single_job.css('div.mb-2')[0]
      #     doc = browser.current_response
      #     single_job = doc.css('div.mb-2')[0]
      #     job_url = single_job.css('a.job-row').attribute('href')
      #     job_role = single_job.css('h2.job-title')[0].text.strip().gsub(/\n/, "")
      #     job_company_name = single_job.css('div.company-title span')[0].text.strip().gsub(/\n/, "")
      #     job_description = single_job.css('div.job-description').text.strip().gsub(/\n/, "")
      #     job_location = "Greater NYC area"

      #     puts ' ===== '
      #     puts job_company_name
      #     puts job_role
      #     puts job_location
      #     # puts job_salary
      #     puts job_description
      #     puts job_url
      #     puts " ===== "
      #     job = {
      #       company: job_company_name, 
      #       role: job_role, 
      #       location: job_location, 
      #       # salary_info: job_salary,
      #       job_description: job_description,
      #       posting: job_url,
      #     }
      #     @@jobs << job

      #   # browser.all(:css, 'div.load-more-button').click
      #   # browser.find(:css, 'div.load-more-button').click
      #   # x = browser.find(:css, 'div.load-more-button')
      #   # doc.first('div.load-more-button').click
      #   # document.getElementById("myButton").click();
      #   # sleep 2
      # end  

    #   # we want to delete the LI so that the dom will render the next job (only shows 7 until scroll)
      doc.css('div.job-item')[0].remove
      browser.execute_script("document.querySelector('div.job-item').remove()") 
      sleep 0.1
    
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
