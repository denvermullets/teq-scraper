require 'kimurai'

class JobScraper < Kimurai::Base
  @name= 'eng_job_scraper'
  @start_urls = ["https://www.indeed.com/jobs?q=software+engineer&l=New+York%2C+NY"]
  @engine = :selenium_chrome

  @@jobs = []

  def scrape_page
    doc = browser.current_response
    returned_jobs = doc.css('td#resultsCol')
    returned_jobs.css('div.jobsearch-SerpJobCard').each do |char_element|
      # scraping individual listings 
      title = char_element.css('h2 a')[0].attributes["title"].value.gsub(/\n/, "")
      link = "https://indeed.com" + char_element.css('h2 a')[0].attributes["href"].value.gsub(/\n/, "")
      description = char_element.css('div.summary').text.gsub(/\n/, "")
      company = description = char_element.css('span.company').text.gsub(/\n/, "")
      location = char_element.css('div.location').text.gsub(/\n/, "")
      salary = char_element.css('div.salarySnippet').text.gsub(/\n/, "")
      requirements = char_element.css('div.jobCardReqContainer').text.gsub(/\n/, "")

      # creating a job object
      job = {title: title, link: link, description: description, company: company, location: location, salary: salary, requirements: requirements}

      # adding the object if it is unique
      @@jobs << job if !@@jobs.include?(job)
    end
  end

  def parse(response, url:, data: {})
    scrape_page

    # take a screenshot of the page
    browser.save_screenshot

    # find the "next" button + click to move to the next page
    browser.find('/html/body/table[2]/tbody/tr/td/table/tbody/tr/td[1]/nav/div/ul/li[6]/a/span').click
    puts "🔹 🔹 🔹 CURRENT NUMBER OF JOBS: #{@@jobs.count}🔹 🔹 🔹" 
    
    @@jobs
  end
end

JobScraper.crawl!