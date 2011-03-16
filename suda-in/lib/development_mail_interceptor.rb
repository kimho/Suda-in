class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "To: #{message.to}, #{message.subject}"
    message.to = APP_CONFIG['administrator_mail']
  end
end
