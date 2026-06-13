class HomeController < ApplicationController
  def index
    # Signed-in users go to their library; guests see the auth landing page.
    return redirect_to dashboard_path if user_signed_in?

    # Build blank resources so the sign in / sign up forms have objects to bind to.
    @sign_in_user = User.new
    @sign_up_user = User.new
  end
end
