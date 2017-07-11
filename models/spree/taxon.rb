# TODO let friendly id take care of sanitizing the url
# require 'stringex'
# require 'friendly_id'
# require File.dirname(__FILE__) + '/../../brand_cruz_config.rb'
module Spree
  class Taxon < ActiveRecord::Base
    self.table_name_prefix = 'spree_'
    extend FriendlyId
    friendly_id :permalink, slug_column: :permalink, use: :slugged
    before_create :set_permalink

    has_many :classifications, -> { order(:position) }, dependent: :delete_all, inverse_of: :taxon
    has_many :products, through: :classifications


    def set_permalink
      parent = Spree::Taxon.find_by_id(self.parent_id)
      if parent.present?
        self.permalink = [parent.permalink, (permalink.blank? ? name.to_url : permalink.split('/').last)].join('/')
      else
        self.permalink = name.to_url if permalink.blank?
      end
    end
  end
end
