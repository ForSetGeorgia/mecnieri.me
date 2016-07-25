# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Allows authorization of certain actions based on user role
class Role < ActiveRecord::Base
  has_many :users
end
