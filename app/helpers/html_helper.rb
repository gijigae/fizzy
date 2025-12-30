module HtmlHelper
  def format_html(html)
    fragment = Loofah::HTML5::DocumentFragment.parse(html)
    unwrap_empty_anchors(fragment)
    fragment.scrub!(AutoLinkScrubber.new).to_html.html_safe
  end

  private
    def unwrap_empty_anchors(fragment)
      fragment.css("a:not([href]), a[href='']").each do |anchor|
        anchor.replace(Nokogiri::HTML.fragment(anchor.inner_html))
      end
    end
end
