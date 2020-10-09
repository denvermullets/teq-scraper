require 'kimurai'
require 'json'

class JobScraper < Kimurai::Base
  @name = 'tqdb_scrap'
  @start_urls = JSON.parse(File.read("tmp/teq-pages.json"))
  # @start_urls = ["https://tequilamatchmaker.com/tequilas/5954-patron-en-lalique-serie-2"]
  @engine = :selenium_chrome
  
  @@tequilas = []

  def scrape_page
    sleep 2
    doc = browser.current_response
    tequila = doc.css('div.product-actions')

    teq_name = tequila.css('h1[itemprop="name"]').text.gsub(/\n/, "")
    teq_type = tequila.css('div.product-type a').text.gsub(/\n/, "")
    teq_rating_p = tequila.css('ul.product-list__item__ratings li')[0].text.gsub(/\D/, '').gsub(/\n/, "")
    teq_rating_c = tequila.css('ul.product-list__item__ratings li')[1].text.gsub(/\D/, '').gsub(/\n/, "")
    # teq_price = tequila.css('div.commerce-price-container div span')[1].text.gsub(/\n/, "")
    teq_price_check = tequila.css('div.commerce-price-container div span')[1]
    if teq_price_check
      teq_price = tequila.css('div.commerce-price-container div span')[1].text.gsub(/\n/, "")
    else
      teq_price = 'n/a'
    end
    
    doc_mid = doc.css('div.container')
    teq_image = doc_mid.css('img.product-image').attr('src')

    teq_nom = doc_mid.css('div.production-details_product table tbody tr')[0].css('td a').text.gsub(/\n/, "")
    doc_mid.search('span.sr-only').each do |spans|
      # remove search result spans since it's just a comma
      spans.remove
    end 
    teq_agave = doc_mid.css('div.production-details_product table tbody tr')[1].css('td').text.gsub(/\n/, "")
    teq_agave_region = doc_mid.css('div.production-details_product table tbody tr')[2].css('td').text.gsub(/\n/, "")
    teq_region = doc_mid.css('div.production-details_product table tbody tr')[3].css('td').text.gsub(/\n/, "")
    teq_cooking = doc_mid.css('div.production-details_product table tbody tr')[4].css('td').text.gsub(/\n/, "")
    teq_extraction = doc_mid.css('div.production-details_product table tbody tr')[5].css('td').text.gsub(/\n/, "")
    teq_water = doc_mid.css('div.production-details_product table tbody tr')[6].css('td').text.gsub(/\n/, "")
    teq_fermentation = doc_mid.css('div.production-details_product table tbody tr')[7].css('td').text.gsub(/\n/, "")
    teq_distillation = doc_mid.css('div.production-details_product table tbody tr')[8].css('td').text.gsub(/\n/, "")
    teq_still = doc_mid.css('div.production-details_product table tbody tr')[9].css('td').text.gsub(/\n/, "")
    teq_aging = doc_mid.css('div.production-details_product table tbody tr')[10].css('td').text.gsub(/\n/, "")
    teq_abv = doc_mid.css('div.production-details_product table tbody tr')[11].css('td').text.gsub(/\n/, "")
    teq_other = doc_mid.css('div.production-details_product table tbody tr')[12].css('td').text.gsub(/\n/, "")

    tequila = {name: teq_name, type: teq_type, rating_p: teq_rating_p, rating_c: teq_rating_c,
      price: teq_price, image_url: teq_image, nom: teq_nom, agave: teq_agave, agave_region: teq_agave_region,
      region: teq_region, cooking: teq_cooking, extraction: teq_extraction, water: teq_water, fermentation: teq_fermentation,
      distillation: teq_distillation, still: teq_still, aging: teq_aging, abv: teq_abv, other: teq_other}

    @@tequilas << tequila #if !@@tequilas.include?(tequila)
  end

  def parse(response, url:, data: {})

        scrape_page

        puts "🥃 🥃 🥃 🥃 🥃 CURRENT NUMBER OF TEQUILAS: #{@@tequilas.count} 🥃 🥃 🥃 🥃 🥃"

        File.open("tequila.json","w") do |f|
        f.write(JSON.pretty_generate(@@tequilas))
    end
    
    @@tequilas
  end
end

JobScraper.crawl!
puts 'done scraping'