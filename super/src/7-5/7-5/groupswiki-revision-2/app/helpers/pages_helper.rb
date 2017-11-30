module PagesHelper

  def format_name(name)
    sentence_case(name.gsub(/_/,' '))
  end

  def sentence_case(string)
    string.split.map{|s|s.capitalize}.join ' '
  end 
  
  def prepare_for_diff(html)
    html.gsub(/&.+?;/,'').gsub(/<.+?>/,'.').gsub(/\s+/,' ').gsub(/[\r\n]/,'.').gsub(/\.+/,'.')
  end
  
  def diff(a, b)
    a1 = a.split(/\./)
    b1 = b.split(/\./)
    
    
    additions = a1.reject do |term|
      b1.include?(term)
    end
    
    subtractions = b1.reject do |term|
      additions.include?(term) or a1.include?(term)
    end
    
    puts additions.inspect
    puts subtractions.inspect
    
    additions.map do |term|
      "<span class='addition'>#{h term}</span>"
    end.join(', ') + 
    subtractions.map do |term|
      "<span class='deletion'>#{h term}</span>"
    end.join(', ')
  end
end
