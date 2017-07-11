# require File.dirname(__FILE__) + '/../../brand_cruz_config.rb'
require 'active_record'
module Spree
  class ProductTaxon < ActiveRecord::Base
    # establish_connection(
    #     :adapter => "postgresql",
    #     :host => "localhost",
    #     :username => "postgres",
    #     :password => "password",
    #     :database => "brandcruz_live_import_product",
    #     :pool => 90
    # )
    self.table_name_prefix = 'spree_'
  end
end