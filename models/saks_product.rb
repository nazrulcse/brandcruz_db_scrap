require 'active_record'
class SaksProduct < ActiveRecord::Base
  self.establish_connection(
      :adapter => "mysql2",
      :username => "root",
      :password => "password",
      :database => "saksfifthavenue"
  )

  self.table_name = 'temp'
end