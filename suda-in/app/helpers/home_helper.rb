module HomeHelper
  def link_user(txt)
  	if match = txt.match(/.*?(@)((?:[a-z0-9][a-z0-9]+))(:|\s)/i)
      user = match[2]
      if user
        txt.gsub!(user, "<a href='#{request.env["SERVER_ADDR"]}/#{user}'>#{user}</a>")
      end
    end
  	txt
  end
  
  def link_url(txt)
    auto_link(txt, :html => { :target => '_blank' }) do |text|
      truncate(text, :length => 15)
    end
  end
end
