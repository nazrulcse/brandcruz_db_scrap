# module Attendance
class Spree::Base < ActiveRecord::Base
   self.abstract_class = true
  self.table_name_prefix = 'spree_'
end
# end