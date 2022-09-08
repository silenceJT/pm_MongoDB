class ApplicationController < ActionController::Base
  # skip_before_action :verify_authenticity_token
  def verify_email
    redirect_to(root_path) unless current_user.admin?
  end
end
