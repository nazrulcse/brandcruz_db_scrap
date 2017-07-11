# require File.dirname(__FILE__) + '/../config.rb'
class Size < ActiveRecord::Base
  ActiveRecord::Base.establish_connection(
      :adapter => "mysql2",
      :host => "localhost",
      :username => "root",
      :password => "root",
      :database => "shopbop",
      :pool => 90
  )
  self.table_name = 'Size'
  belongs_to :item ,class_name: 'Item'
end