# require File.dirname(__FILE__) + '/../config.rb'
class Category < ActiveRecord::Base
  ActiveRecord::Base.establish_connection(
      :adapter => "mysql2",
      :host => "localhost",
      :username => "root",
      :password => "root",
      :database => "shopbop",
      :pool => 90
  )

  self.table_name = 'Category'
end