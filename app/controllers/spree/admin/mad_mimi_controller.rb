class Spree::Admin::MadMimiController < Spree::Admin::BaseController

  before_filter :grab_webforms

  def edit
  end

  def update
    ::MadMimi.webform_id = params[:webform_id] if ::MadMimi.connected?
    if ::MadMimi.webform_visible?
      flash[:success] = Spree.t('mad_mimi.admin.controller.mad_mimi.update.flash.success')
    else
      flash[:notice] = Spree.t('mad_mimi.admin.controller.mad_mimi.update.flash.notice')
    end
    redirect_to [:edit, :admin, :mad_mimi]
  end

  private

    def grab_webforms
      @webforms = ::MadMimi.webforms
    end

end
