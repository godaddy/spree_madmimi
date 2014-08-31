class Spree::Admin::SessionsController < Spree::Admin::BaseController
  def create
    result = update_token_params
    if result.successful?
      flash[:success] = Spree.t('mad_mimi.admin.controller.sessions.create.flash.success')
    else
      flash[:error] = Spree.t('mad_mimi.admin.controller.sessions.create.flash.error', message: result.errors.to_sentence)
    end
    close_window
  end

  def failure
    flash[:error] = Spree.t('mad_mimi.admin.controller.sessions.failure.flash.error', message: params[:message])
    close_window
  end

  def destroy
    result = clear_token_params
    if result.successful?
      flash[:success] = Spree.t('mad_mimi.admin.controller.sessions.destroy.flash.success')
    else
      flash[:error] = Spree.t('mad_mimi.admin.controller.sessions.destroy.flash.error', message: result.errors.to_sentence)
    end
    head :ok
  end

  private

    def auth_hash
      request.env['omniauth.auth']
    end

    def update_token_params
      ::MadMimi.connect({
        access_token:  auth_hash.credentials.token,
        refresh_token: auth_hash.credentials.refresh_token,
        store_url:     store_url
      })
    end

    def clear_token_params
      ::MadMimi.disconnect
    end

    def close_window
      render :close_window
    end

    def store_url
      request.protocol + request.host_with_port
    end

end
