# require File.dirname(__FILE__) + '/../../brand_cruz_config.rb'
require 'active_record'
require 'friendly_id'
module Spree
  class Brand < ActiveRecord::Base
    # self.abstract_class = true
    # establish_connection(
    #     :adapter => "postgresql",
    #     :host => "localhost",
    #     :username => "postgres",
    #     :password => "password",
    #     :database => "brandcruz_live_import_product",
    #     :pool => 90
    # )
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
    self.table_name_prefix = 'spree_'

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end
  end
end