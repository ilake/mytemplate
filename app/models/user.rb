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

  def activate!
    self.active = true
    save
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end
end
