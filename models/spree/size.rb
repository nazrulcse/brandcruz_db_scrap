require File.dirname(__FILE__) + '/../../brand_cruz_config.rb'
module Spree
  class Size < ActiveRecord::Base
    # establish_connection(
    #     :adapter => "postgresql",
    #     :host => "localhost",
    #     :username => "postgres",
    #     :password => "password",
    #     :database => "spree_development",
    #     :pool => 90
    # )
    self.table_name_prefix = 'spree_'

    belongs_to :product, :class_name => 'Spree::Product'
  end
end