# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  role_id                :integer
#

# Contains account data
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  belongs_to :role
  # Email already required by devise
  validates :role, presence: true

  # requested_role may be the name of one role (a string)
  # or an array of possible roles
  def is?(requested_role)
    self.role_id && ((requested_role.is_a?(String) && role.name == requested_role) || (requested_role.is_a?(Array) && requested_role.include?(self.role.name)))
  end

  def manageable_roles
    Role.all.select { |role| Ability.new(self).can? :manage, role }
  end
end
