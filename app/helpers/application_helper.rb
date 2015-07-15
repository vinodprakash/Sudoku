module ApplicationHelper
  #Returns the title for the application
  def title
    base_title = "Sudoku Generator and Player"
    if @title.nil?
      base_title
    else
      "#{base_title}"
    end
  end
end
