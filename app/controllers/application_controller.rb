# The central controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_global_vars

  ##############################################
  # Locales #

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    gon.locale = I18n.locale
  end
  private :set_locale

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  ##############################################
  # helpers

  def set_global_vars
    # indicate if the page title should be shown on the page
    # if false, then it will only be used in <title> tag
    @show_page_title = true

    # use this to set custom css class in body tag
    @body_class = nil
    
    gon.addthis_id = ENV['ADDTHIS_ID']

    gon.facebook_id = ENV['FACEBOOK_APP_ID']

    @categories = Category.active.sorted
  end

  def clean_filename(filename)
    filename.strip.to_slug.transliterate.to_s.gsub(' ', '_').gsub(/[\\ \/ \: \* \? \" \< \> \| \, \. ]/,'')
  end


  def create_pdf_file
    html = render_to_string(:layout => false , :template => "root/experiment_pdf.html.erb", :formats => [:html], :handler => [:erb])
    kit = PDFKit.new(html)
    full_path = "#{request.protocol}#{request.host_with_port}"
    css = view_context.asset_path('experiment_pdf.css')
    kit.stylesheets << "#{Rails.root}/public#{css}"

    return kit.to_pdf
  end

  def create_pdf_filename(experiment_title)
    return clean_filename("#{I18n.t('shared.common.name')} - #{experiment_title}")
  end

  ##############################################
  # Authorization #

  # role is either the name of the role (string) or an array of role names (string)
  def valid_role?(role)
    redirect_to root_path(locale: I18n.locale), :notice => t('shared.msgs.not_authorized') if !current_user || !((role.is_a?(String) && current_user.is?(role)) || (role.is_a?(Array) && role.include?(current_user.role.name)))
  end

  rescue_from CanCan::AccessDenied do |_exception|
    if user_signed_in?
      not_authorized(root_path(locale: I18n.locale))
    else
      not_authorized
    end
  end

  def not_authorized(redirect_path = new_user_session_path)
    redirect_to redirect_path, alert: t('shared.msgs.not_authorized')
  rescue ActionController::RedirectBackError
    redirect_to root_path(locale: I18n.locale)
  end

  def not_found(redirect_path = root_path(locale: I18n.locale))
    Rails.logger.debug('Not found redirect')
    redirect_to redirect_path,
                notice: t('shared.msgs.does_not_exist')
  end
end
