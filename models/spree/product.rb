# PRODUCTS
# Products represent an entity for sale in a store.
# Products can have variations, called variants
# Products properties include description, permalink, availability,
#   shipping category, etc. that do not change by variant.
#
# MASTER VARIANT
# Every product has one master variant, which stores master price and sku, size and weight, etc.
# The master variant does not have option values associated with it.
# Price, SKU, size, weight, etc. are all delegated to the master variant.
# Contains on_hand inventory levels only when there are no variants for the product.
#
# VARIANTS
# All variants can access the product properties directly (via reverse delegation).
# Inventory units are tied to Variant.
# The master variant can have inventory units, but not option values.
# All other variants have option values and may have inventory units.
# Sum of on_hand each variant's inventory level determine "on_hand" level for the product.
#
# require File.dirname(__FILE__) + '/../../brand_cruz_config.rb'
require 'active_record'
require 'friendly_id'
module Spree
  class Product < ActiveRecord::Base
    # establish_connection(
    #     :adapter => "postgresql",
    #     :host => "localhost",
    #     :username => "postgres",
    #     :password => "password",
    #     :database => "brandcruz_live_import_product",
    #     :pool => 90
    # )
    self.table_name_prefix = 'spree_'
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
    has_many :classifications, dependent: :delete_all, inverse_of: :product
    has_many :taxons, through: :classifications, before_remove: :remove_taxon
    has_many :product_sizes, :class_name => 'Spree::Size'

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end
  end
end
