module HtmlHelper
  def format_html(html)
    fragment = Loofah::HTML5::DocumentFragment.parse(html)
    unwrap_empty_anchors(fragment)
    fragment.scrub!(AutoLinkScrubber.new).to_html.html_safe
  end

  def card_html_title(card)
    return card.title if card.title.blank?

    ERB::Util.html_escape(card.title).gsub(/`([^`]+)`/, '<code>\1</code>').html_safe
  end

  private
    def unwrap_empty_anchors(fragment)
      fragment.css("a:not([href]), a[href='']").each do |anchor|
        anchor.replace(Nokogiri::HTML.fragment(anchor.inner_html))
      end
    end
end
