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

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:super_admin_role) { FactoryGirl.create(:role, name: 'super_admin') }
  let!(:site_admin_role) { FactoryGirl.create(:role, name: 'site_admin') }
  let!(:content_manager_role) do
    FactoryGirl.create(:role, name: 'content_manager')
  end

  let(:new_user) { FactoryGirl.build(:user) }

  it 'is valid with valid attributes' do
    expect(new_user).to be_valid
  end

  describe 'email' do
    it 'is required' do
      new_user.email = ''
      expect(new_user).to have(1).error_on(:email)
    end
  end

  describe 'role' do
    it 'is required' do
      new_user.role = nil
      expect(new_user).to have(1).error_on(:role)
    end
  end

  describe '#manageable_roles' do
    context 'when is super_admin' do
      let(:super_admin_user) do
        FactoryGirl.create(:user, role: super_admin_role)
      end

      it 'includes super_admin' do
        expect(super_admin_user.manageable_roles).to include(super_admin_role)
      end

      it 'includes site_admin' do
        expect(super_admin_user.manageable_roles).to include(site_admin_role)
      end

      it 'includes content_manager' do
        expect(super_admin_user.manageable_roles)
          .to include(content_manager_role)
      end
    end

    context 'when is site_admin' do
      let(:site_admin_user) do
        FactoryGirl.create(:user, role: site_admin_role)
      end

      it 'does not include super_admin' do
        expect(site_admin_user.manageable_roles)
          .not_to include(super_admin_role)
      end

      it 'includes site_admin' do
        expect(site_admin_user.manageable_roles).to include(site_admin_role)
      end

      it 'includes content_manager' do
        expect(site_admin_user.manageable_roles)
          .to include(content_manager_role)
      end
    end

    context 'when is content_manager' do
      let(:content_manager_user) do
        FactoryGirl.create(:user, role: content_manager_role)
      end

      it 'does not include super_admin' do
        expect(content_manager_user.manageable_roles)
          .not_to include(super_admin_role)
      end

      it 'does not include site_admin' do
        expect(content_manager_user.manageable_roles)
          .not_to include(site_admin_role)
      end

      it 'does not include content_manager' do
        expect(content_manager_user.manageable_roles)
          .not_to include(content_manager_role)
      end
    end
  end
end
