# require File.dirname(__FILE__) + '/../../brand_cruz_config.rb'
require 'active_record'
module Spree
  class Classification < ActiveRecord::Base
    # establish_connection(
    #     :adapter => "postgresql",
    #     :host => "localhost",
    #     :username => "postgres",
    #     :password => "password",
    #     :database => "brandcruz_live_import_product",
    #     :pool => 90
    # )
    self.table_name = 'spree_products_taxons'

    # # with_options inverse_of: :classifications, touch: true do
    #   belongs_to :product, class_name: "Spree::Product"
    #   belongs_to :taxon, class_name: "Spree::Taxon"
    # # end
    #
    # validates :taxon, :product, presence: true
    # # For #3494
    # validates :taxon_id, uniqueness: { scope: :product_id, message: :already_linked, allow_blank: true }
  end
end
