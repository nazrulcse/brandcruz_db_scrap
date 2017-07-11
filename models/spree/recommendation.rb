module Spree
  class Recommendation < ActiveRecord::Base
    self.table_name_prefix = 'spree_'
  end
end