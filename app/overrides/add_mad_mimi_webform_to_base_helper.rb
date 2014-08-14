Spree::BaseHelper.module_eval do

  SUPPORTED_STYLES          = [:side_tab, :plain]
  UNSUPPORTED_STYLE_MESSAGE = "%{style} Mad Mimi webform style is not supported."

  def mad_mimi_webform(id = nil, style = :side_tab)
    check_style(style)

    if MadMimi.connected?
      MadMimi.webform(id).try{ |wf| wf.send("#{ style }_embed_code").html_safe }
    end
  end

  private

  def check_style(style)
    unless SUPPORTED_STYLES.include?(style.to_sym)
      if Rails.env.production?
        raise NotImplementedError, UNSUPPORTED_STYLE_MESSAGE % { style: style }
      else
        p UNSUPPORTED_STYLE_MESSAGE % { style: style }
      end
    end
  end

end
