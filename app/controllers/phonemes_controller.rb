class PhonemesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_email
  
  def index
  end
end