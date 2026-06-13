class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { member: 0, admin: 1 }

  ADMIN_EMAIL = "nirmalworkspace@gmail.com".freeze

  before_validation :assign_role_from_email, on: :create

  private

  # On signup the admin email becomes an admin; everyone else is a member.
  def assign_role_from_email
    self.role = email.to_s.strip.casecmp?(ADMIN_EMAIL) ? :admin : :member
  end
end
