require File.dirname(__FILE__) + '/../../models/spree/product.rb'
require File.dirname(__FILE__) + '/../../models/spree/variant.rb'
require File.dirname(__FILE__) + '/../../models/spree/stock_item.rb'
require File.dirname(__FILE__) + '/../../models/spree/size.rb'
require File.dirname(__FILE__) + '/../../models/spree/brand.rb'
require File.dirname(__FILE__) + '/../../models/spree/price.rb'
require File.dirname(__FILE__) + '/../../models/spree/asset.rb'
require File.dirname(__FILE__) + '/../../models/spree/classification.rb'
require File.dirname(__FILE__) + '/../../models/spree/taxon.rb'
require File.dirname(__FILE__) + '/../../models/spree/taxonomy.rb'
require File.dirname(__FILE__) + '/../../config.rb'
require File.dirname(__FILE__) + '/../../lib/scraper/logger.rb'

require 'httparty'

module Scraper
  class Product
    def self.build(product_info, images, colors, category, index)
      category_info = find_sub_category(category)
      unless category_info.nil?
        id = 0
        begin
          id = Spree::Product.maximum(:id).to_i + 1
          taxon_id = category_info[:taxons].first
          taxonomy_id = category_info[:taxonomy_id]
          images = exec_obj(images)
          colors = exec_obj(colors)
          master_image = get_master_image(images)
          additional_images = get_additional_image(images)
          product = Spree::Product.new(id: id, source: 'saksfitavanue')
          brand_name = product_info[:brand]
          product.name = "#{brand_name} " + self.replace_text(product_info[:name])
          product.description = self.replace_text(product_info[:description])
          product.sizechart = product_info[:chart]
          product.available_on = DateTime.now
          product.meta_description = "#{product.name} FREE Shipping. Read #{product.name} Reviews or select the size, color of your choice."
          product.meta_keywords = "#{brand_name}, #{product.name}, Brandcruz shopping, Brandcruz.com, Brandcruz"
          product.meta_title = "#{product.name} at Brandcruz.com"
          brand = Spree::Brand.find_or_create_by({name: brand_name, taxon_id: taxon_id, taxonomy_id: taxonomy_id})
          product.brand_id = brand.id
          product.created_at = DateTime.now - 200
          product.save

          p "index #{index}"
          Logger.log_write('product_save.txt', "Product saved with id: #{product.id} and taxon: #{Spree::Taxon.find(taxon_id).permalink} tax_id: #{taxon_id} index: #{index} \n")

          # Create variant

          variant = Spree::Variant.create!(product_id: product.id, is_master: true)
          price = Spree::Price.create!(variant_id: variant.id, amount: product_info[:price][:amount], selling_price: product_info[:price][:original], original_price: product_info[:price][:original], currency: 'USD')
          Spree::StockItem.create!(variant_id: variant.id, stock_location_id: 1, count_on_hand: 100000)
          Spree::Asset.create!(viewable_id: variant.id, viewable_type: variant.class, image_link: master_image[:src], zoomable_image_link: master_image[:zoom])

          category_info[:taxons].each do |tax_id|
            Spree::Classification.find_or_create_by(product_id: product.id, taxon_id: tax_id)
          end

          self.create_additional_image(variant, additional_images)

          # Create product color

          colors.each_with_index do |color, ind|
            if color[:src].present?
              color_src = color[:src]
            else
              color_src = color_src_image(ind, additional_images, master_image)
            end
            variant = Spree::Variant.create(product_id: product.id, is_master: false, color: color[:alt], color_image: color_src)
            Spree::Price.create(variant_id: variant.id, amount: product_info[:price][:amount], selling_price: product_info[:price][:original], original_price: product_info[:price][:original], currency: 'USD')
            Spree::StockItem.create(variant_id: variant.id, stock_location_id: 1, count_on_hand: 100000)
            Spree::Asset.create(viewable_id: variant.id, viewable_type: variant.class, image_link: master_image[:src], zoomable_image_link: master_image[:zoom])
            self.create_additional_image(variant, additional_images)
          end

          sizes = exec_obj(product.sizechart)
          if sizes && sizes[:sizes].present?
            sizes[:sizes].each do |size|
              obj_size = {text: size, short_name: size, applicable: true}
              product.product_sizes.find_or_create_by(obj_size)
            end
          end

        rescue => ex
          p ex.message
          log_write(id, ex.message)
        end
      end
    end

    def self.is_master_image_exist?(image)
      response = HTTParty.get(image[:src])
      response.code == 200
    end

    def self.color_src_image(index, additional_images, master_image)
      if index >= additional_images.length
        image_src = master_image[:src]
      else
        image_src = additional_images[index][:src]
      end
      image_src.length == 7 ? image_src : image_src + '?fit=constrain,1&wid=60&hei=40&fmt=jpg'
    end

    def self.create_additional_image(variant, images)
      images.each do |image|
        Spree::Asset.create!(viewable_id: variant.id, viewable_type: variant.class, image_link: image[:src], zoomable_image_link: image[:zoom])
      end
    end

    def self.calculate_price(original)
      case original
        when 0..99
          return (original - (original * 0.25))
        when 100..150
          return (original - (original * 0.325))
        when 151..200
          return (original - (original * 0.305))
        when 201..400
          return (original - (original * 0.359))
        when 401..750
          return (original - (original * 0.427))
        when 751..1000
          return (original - (original * 0.335))
        when 1001..1500
          return (original - (original * 0.418))
        when 1501..2000
          return (original - (original * 0.636))
        when 2001..3000
          return (original - (original * 0.721))
        when 3001..4000
          return (original - (original * 0.557))
        else
          return (original - (original * 0.537))
      end
    end

    def self.replace_text(text)
      text = text
      if text.include? "saksfitavanue"
        text = text.gsub! "saksfitavanue", 'brandcruz'
      end

      if text.include? "saksfifthavenue"
        text = text.gsub! "saksfifthavenue", 'BRANDCRUZ'
      end

      if text.include? "Saksfifthavenue"
        text = text.gsub! "Saksfifthavenue", 'Brandcruz'
      end
      return text
    end

    def self.find_sub_category(categories)
      categories = categories.gsub('[', '').gsub(']', '').split(',')
      if categories
        taxonomy = categories.first
        taxonomy = map_taxonomy(taxonomy)
        unless taxonomy.nil?
          taxons = []
          categories.each_with_index do |sub_cat, index|
            if index > 0
              taxon = Spree::Taxon.where("lower(name) = ? and taxonomy_id = #{taxonomy.id} and parent_id IS NOT NULL", map_category(sub_cat)).order(:id).first
              if taxon.present?
                taxons.push(taxon.id)
              else
                taxon = Spree::Taxon.where("lower(name) = ? and taxonomy_id = #{taxonomy.id} and parent_id IS NULL", map_category(sub_cat)).order(:id).first
                if taxon.present?
                  taxon = Spree::Taxon.where(permalink: taxon.permalink).order(:id).first
                  taxons.push(taxon.id) if taxon.present?
                end
              end
            end
          end
          if taxons.empty?
            Logger.log_write('error.txt', "Taxon Not found #{categories.inspect}")
            return nil
          else
            return {taxons: taxons, taxonomy_id: taxonomy.id}
          end
        end
      end
      nil
    end

    def self.get_master_image(images)
      images.each do |image|
        if image[:tag].downcase == 'default'
          src = image[:src]
          return {src: src, zoom: get_zoom_image(src)}
        end
      end
    end

    def self.get_additional_image(images)
      images.collect { |image| {src: image[:src], zoom: get_zoom_image(image[:src])} if image[:tag].downcase != 'default' }.compact
    end

    def self.get_zoom_image(img, width = '')
      img + '?fit=constrain,1&wid=2500&hei=1500&fmt=jpg'
    end

    def self.map_taxonomy(name)
      id = nil
      case name.downcase
        when 'kids'
          id = 6
        when 'shoes'
          id = 9
        when 'men'
          id = 4
        when 'beauty'
          id = 8
        when 'handbags'
          id = 10
        when 'jewelry & accessories'
          id = 11
        when 'home'
          id = 1
        when "women's apparel"
          id = 3
      end
      id.nil? ? id : Spree::Taxonomy.find_by_id(id)
    end

    def self.map_category(cat)
      case cat.strip.downcase
        when 'swimsuits & cover-ups'
          'swimwear'
        when 'sleepwear & loungewear'
          'pajamas, lounge &amp; sleepwear'
        when 'plus & extended sizes'
          'all plus sizes'
        when 'toys'
          'toys &amp; games'
        when 'robes & caftans'
          'pajamas &amp; robes'
        when 'underwear & socks'
          'underwear &amp; undershirts'
        when 'sweaters & sweatshirts'
          'hoodies &amp; sweatshirts'
        when 'baby gear & essentials'
          'baby strollers & gear'
        when 't-shirts & polos'
          'polos'
        else
          cat.strip.downcase
      end
    end

    def self.exec_obj(str)
      begin
        eval(str)
      rescue => ex
        nil
      end
    end

    def self.log_write(product_id, message)
      File.open("error_nordstrom.txt", 'a') { |f| f.write("#{message} \n") }
      # File.open("error_nordstrom.txt", 'a') { |f| f.write("product ID: #{product_id} | Message: #{message} \n") }
    end

  end

end