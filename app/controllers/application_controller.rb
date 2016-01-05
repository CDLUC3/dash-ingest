class ApplicationController < ActionController::Base
  protect_from_forgery

  include RecordHelper

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def institution
    uri = URI(request.base_url)
    uri = uri.to_s if uri
    logger.info "uriabcdefg #{uri.inspect} "
    Institution.all.each do |i|
      if Regexp.new(i.external_id_strip).match(uri)
        return i
      end
    end
    nil
  end


end





















