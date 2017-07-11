module Spree
  class Taxonomy < ActiveRecord::Base
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
