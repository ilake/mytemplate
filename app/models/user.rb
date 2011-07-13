# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.login_field = :nickname
  end

  validates :cellphone, :uniqueness => true, :presence => true

  scope :login_recently, order("last_login_at DESC")

  def is_owner?(user)
    @is_owner ||= self == user
  end

  def self.find_by_nickname_or_email(login)
    find_by_nickname(login) || find_by_email(login)
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.welcome_information(self).deliver
  end

  def email_activate!
    self.email_active = true
    save
  end

  def cellphone_activate!
    self.cellphone_active = true
    save
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end
end

# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  nickname            :string(255)     not null
#  email               :string(255)     not null
#  cellphone           :string(255)
#  active              :boolean(1)      default(FALSE)
#  cached_slug         :string(255)
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  nickname            :string(255)     not null
#  email               :string(255)     not null
#  cellphone           :string(255)
#  active              :boolean(1)      default(FALSE)
#  cached_slug         :string(255)
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

