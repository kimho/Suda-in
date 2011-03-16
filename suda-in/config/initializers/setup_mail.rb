ActionMailer::Base.smtp_settings = {
  :address              => APP_CONFIG['smtp_address'],
  :domain               => APP_CONFIG['http_host']
}
ActionMailer::Base.default_content_type = "text/html"

# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
