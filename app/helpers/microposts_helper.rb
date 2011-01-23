module MicropostsHelper
  def wrap(content)
    raw(content.split.map { |s| wrap_long_string(s) }.join(' '))
  end
  
  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
  
  def link_for(text, user)
    if user
      text =~ /\A(@[\w\-.]+)/
      matched = $1
      text.sub(/\A(@[\w\-.]+)/, link_to($1, user_path(user)))
    else
      text
    end
  end
end
