# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_flash
    "<p class='flash'><span>#{flash[:message]}</span></p>" if flash[:message]
  end

  def render_sidebar
    "<div class='col1'>" +
      render(:partial=>'shared/sidebar') + 
    "</div>"
  end

  def render_generic_sidebar
    "<div class='col1'>" +
      render(:partial=>'shared/generic_sidebar') + 
    "</div>"
  end

  def date_ordinal(date)
    d = date.strftime("%d").to_i
    if d == 1 or d == 21 or d == 31
      return "st"
    elsif d == 2 or d == 22
      return "nd"
    elsif d == 3 or d == 23
      return "rd"
    else
      return "th"
    end
  end
    
end
