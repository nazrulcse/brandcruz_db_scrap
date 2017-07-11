require 'active_record'
#
# ActiveRecord::Base.establish_connection(
#     :adapter => "mongoid",
#     :hosts => "localhost:27017",
#     :database => "nmo_data"
# )
# require "mongo_mapper"
# require 'mongoid'
#
# MongoMapper.config = {op_timeout: 30}
# MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
# MongoMapper.database = 'mno_data'

# db = Mongo::Client.new.db("mydb") # OR
#db = Mongo::Connection.new("localhost").db("mydb") # OR
# Mongo::Client.new(['localhost:27017'], :database => 'mno_data', defualt: true)
#
# Mongoid.load_configuration(clients: {
#                                default: {
#                                    database: 'mno_data',
#                                    hosts: ['localhost:27017']
#                                }
#                            })

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :host => "localhost",
    :username => "postgres",
    :password => "password",
    :database => "brandcruz_live_import_product_1",
    :pool => 90
)