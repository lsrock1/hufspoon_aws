module OhomeHelper
  def oLan_collection
    @languageHash[@language]["active"] = "active"
    content_tag(:div, class: :collection) do 
      @languageHash.collect do |key, item|
        concat content_tag(:a, item["showName"], class: "collection-item #{item["active"]}", onclick: "languageChange(#{key})")
      end
    end
  end
  
  def button_table key
    if key == nil
      content_tag(:table, class: "package centered card") do
        concat(content_tag(:tr) do
          concat content_tag(:td, "")
          concat content_tag(:td, "")
          concat content_tag(:td, "")
        end)
        concat(content_tag(:tr) do
          concat content_tag(:td, "")
          concat content_tag(:td, "", class: :mid)
          concat content_tag(:td, "")
        end)
        concat(content_tag(:tr) do
          concat content_tag(:td, "")
          concat content_tag(:td, "")
          concat content_tag(:td, "")
        end)
      end
    else
      content_tag(:table, class: "package centered card") do
        concat(content_tag(:tr) do
          concat content_tag(:td, content_tag(:a, @category[key][0]&&"#{@category[key][0].name}", href: @category[key][0]&&"/rests/#{@category[key][0].id}"))
          concat content_tag(:td, content_tag(:a, @category[key][1]&&"#{@category[key][1].name}", href: @category[key][1]&&"/rests/#{@category[key][1].id}"))
          concat content_tag(:td, content_tag(:a, @category[key][2]&&"#{@category[key][2].name}", href: @category[key][2]&&"/rests/#{@category[key][2].id}"))
        end)
        concat(content_tag(:tr) do
          concat content_tag(:td, content_tag(:a, @category[key][3]&&"#{@category[key][3].name}", href: @category[key][3]&&"/rests/#{@category[key][3].id}"))
          concat content_tag(:td, "#{key}", class: "mid")
          concat content_tag(:td, content_tag(:a, @category[key][4]&&"#{@category[key][4].name}", href: @category[key][4]&&"/rests/#{@category[key][4].id}"))
        end)
        concat(content_tag(:tr) do
          concat content_tag(:td, content_tag(:a, @category[key][5]&&"#{@category[key][5].name}", href: @category[key][5]&&"/rests/#{@category[key][5].id}"))
          concat content_tag(:td, content_tag(:a, @category[key][6]&&"#{@category[key][6].name}", href: @category[key][6]&&"/rests/#{@category[key][6].id}"))
          concat content_tag(:td, content_tag(:a, @category[key][7]&&"#{@category[key][7].name}", href: @category[key][7]&&"/rests/#{@category[key][7].id}"))
        end)
      end
    end
  end
end
