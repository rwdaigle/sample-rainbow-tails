module LayoutHelper

  def flash_value
    flash.collect do |key, value|
      %{<div class="alert alert-#{key}">#{value}</div>}
    end.join("\n").html_safe
  end

end
