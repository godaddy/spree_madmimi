class Spree::Admin::MadMimiController < Spree::Admin::BaseController

  def edit
  end

  def update
    ::MadMimi.webform_id = params[:webform_id] if ::MadMimi.connected?
    render :edit
  end

end
