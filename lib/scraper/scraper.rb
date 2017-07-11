require File.dirname(__FILE__) + '/logger.rb'
require File.dirname(__FILE__) + '/../../models/saks_product.rb'
require File.dirname(__FILE__) + '/../../lib/scraper/product.rb'
require File.dirname(__FILE__) + '/../../config.rb'
module Scraper
  require 'active_record'

  def self.run()
    # products = Good.where(source: 'overstock')
    products = SaksProduct.all
    index = 0
    products.each do |pr|
      if index > -1
        images = pr.images
        colors = pr.colors || []
        category = pr.taxonomy
        product_info = {
            name: pr.name,
            description: pr.details,
            price:
                {
                    acp: pr.compPrice.to_f,
                    original: format_price(pr.compPrice),
                    amount: pr.ourPrice.to_f
                },
            chart: pr.sizeChart,
            brand: pr.brand,
            recom: pr.recommendationList
        }

        if product_info[:price][:original] > 0 && product_info[:price][:amount] > 0 && pr.taxonomy.present?
          Scraper::Product.build(product_info, images, colors, category, index)
        else
          log_write('', "Price not found #{product_info[:price]}")
        end
        #end
        if index == 500
          break
        end
      end
      index += 1
    end
  end

  def self.format_price(price)
    org_price = price.gsub('$', '').gsub(',', '')
    org_price.to_f
  end

  def self.log_write(product_id, message)
    File.open("error_nordstrom.txt", 'a') { |f| f.write("#{message} \n") }
    # File.open("error_nordstrom.txt", 'a') { |f| f.write("product ID: #{product_id} | Message: #{message} \n") }
  end

end
