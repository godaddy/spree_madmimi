Spree::BaseHelper.module_eval do

  def mad_mimi_webform(id=nil)
    if MadMimi.connected?
      id ||= MadMimi.webform_id
      webforms = MadMimi.webforms
      if webforms.present?
        webform = id.present? ? webforms.find{ |f| f.id == id } : webforms.first
        webform.try(:side_tab_embed_code).html_safe
      end
    end
  end

end
