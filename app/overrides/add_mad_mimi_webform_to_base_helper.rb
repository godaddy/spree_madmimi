Spree::BaseHelper.module_eval do

  def mad_mimi_webform(id = nil)
    if MadMimi.connected?
      MadMimi.webform(id).try{ |wf| wf.side_tab_embed_code.html_safe }
    end
  end

end
