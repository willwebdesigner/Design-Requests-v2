module ApplicationHelper

  # The logo function to add the header logo into the header partial
  def logo
    logo = image_tag("core/headerLogo.png", :alt => "Request It", :class => "")
  end
    
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
