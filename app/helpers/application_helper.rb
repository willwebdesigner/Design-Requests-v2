module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "Design Request Form"
    if @title.nil? #Could also be spelt as @title == 0
      base_title
    else
      "#{base_title} | #{@title}" 
    end
  end
  
end
