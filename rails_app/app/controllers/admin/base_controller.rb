module Admin
  # Shared base for the admin area — requires a signed-in admin user.
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    private

    def require_admin!
      return if current_user&.admin?

      redirect_to dashboard_path, alert: "Admins only."
    end
  end
end
