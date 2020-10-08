require 'kimurai'

# this scraper will get every url for the product page of tequilas

class TeqScraper < Kimurai::Base
  @name = 'google'
  @start_urls = ["https://tequilamatchmaker.com/tequilas"]
  @engine = :selenium_chrome
  
  @@tequilas = []

  def scrape_page
    sleep 3
    doc = browser.current_response
    returned_tequila = doc.css('div.ais-hits')
    returned_tequila.css('div.ais-hits--item').each do |single_tequila|
      # scrape each individual product listing url for tqdb
      url = "https://tequilamatchmaker.com" + single_tequila.css('a').attribute('href').text
      puts url 
      
      @@tequilas << url if !@@tequilas.include?(url) #original urls only pls
    end
  end

  def parse(response, url:, data: {})
    33.times do
      scrape_page
      # take a screenshot of the page - disabled for now
      # browser.save_screenshot

      # find the "next" button + click to move to the next page
      browser.find('/html/body/div[2]/div[2]/div[2]/div[2]/div[2]/nav/div/div/ul/li[16]/a').click
      puts "🥃 🥃 🥃 🥃 🥃 CURRENT NUMBER OF TEQUILAS: #{@@tequilas.count} 🥃 🥃 🥃 🥃 🥃" 

    end 
    # optional csv export
    # CSV.open('teq-pages.csv', "w") do |csv|
    #   csv << @@tequilas
    # end

    File.open("tmp/teq-pages.json","w") do |f|
        f.write(JSON.pretty_generate(@@tequilas))
    end

    @@tequilas
  end
end

TeqScraper.crawl!
puts 'scraping done'
