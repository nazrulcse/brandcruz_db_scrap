# require File.dirname(__FILE__) + '/../config.rb'
require File.dirname(__FILE__) + '/size.rb'
# require "mongo_mapper"
# require 'active_model/serializers'
require 'mongoid'
class Good #< ActiveRecord::Base
  # include ActiveModel::Serializers::Xml
  # include MongoMapper::Document
  # require 'active_record'
  include Mongoid::Document

  field :source, type: String
  field :brand, type: String
  field :name, type: String
  field :images, type: Hash
  field :colors, type: Hash
  field :details, type: String
  field :compPrice, type: String
  field :ourPrice, type: Float
  field :sizeChart, type: String
  field :taxonomy, type: String
  field :recommendationList, type: Hash
  # self.table_name = 'goods'
  # has_many :size, class_name: "Size"
end