# Loofah scrubber to auto-link URLs and email addresses in HTML text nodes.
#
# This scrubber does not perform HTML sanitization; it's assumed that the input is already sanitized
# (for example, ActionText rich text).
class AutoLinkScrubber < Loofah::Scrubber
  EXCLUDED_ELEMENTS = %w[a figcaption pre code].freeze

  # This regexp is similar to URI::MailTo::EMAIL_REGEXP but uses \b word boundaries instead of \A/\z
  # anchors, allowing it to match email addresses embedded within longer strings.
  #
  # It's named EMAIL_AUTOLINK_REGEXP (not EMAIL_REGEXP) to avoid confusing Brakeman's imprecise
  # constant lookup, which otherwise assumes Identity's email validation uses this \b-anchored pattern.
  # See https://github.com/presidentbeef/brakeman/pull/1981
  EMAIL_AUTOLINK_REGEXP = /\b[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\b/
  URL_REGEXP = URI::DEFAULT_PARSER.make_regexp(%w[http https])
  OBSIDIAN_URL_REGEXP = /obsidian:\/\/[^\s<>"]+/
  # Combined regex to match all URL types in a single pass to avoid corrupting HTML
  # when one URL type contains another (e.g., https://example.com?redirect=obsidian://...)
  COMBINED_URL_REGEXP = Regexp.union(URL_REGEXP, OBSIDIAN_URL_REGEXP)
  AUTOLINK_REGEXP = /(?<url>#{COMBINED_URL_REGEXP})|(?<email>#{EMAIL_AUTOLINK_REGEXP})/

  TRAILING_PUNCTUATION = %(.?,:!;"'<>)
  TRAILING_PUNCTUATION_REGEXP = /[#{Regexp.escape(TRAILING_PUNCTUATION)}]+\z/

  def initialize
    @direction = :top_down
  end

  def scrub(node)
    return Loofah::Scrubber::STOP if EXCLUDED_ELEMENTS.include?(node.name)

    if node.text?
      replacement = autolink_text_node(node)
      node.replace(replacement) if replacement
    end

    Loofah::Scrubber::CONTINUE
  end

  private
    def autolink_text_node(node)
      text = node.text
      links = find_links(text)

      return nil if links.empty?

      doc = node.document
      nodes = Nokogiri::XML::NodeSet.new(doc)
      pos = 0

      links.each do |link|
        nodes << doc.create_text_node(text[pos...link[:start]]) if link[:start] > pos
        nodes << create_link_element(doc, link)
        pos = link[:start] + link[:length]
      end
      nodes << doc.create_text_node(text[pos..]) if pos < text.length

      nodes
    end

    def create_link_element(doc, link)
      if link[:obsidian]
        doc.create_element("a", link[:text], href: link[:href])
      else
        doc.create_element("a", link[:text], href: link[:href], rel: "noopener noreferrer")
      end
    end

    def find_links(text)
      links = []

      text.scan(AUTOLINK_REGEXP) do
        match_data = Regexp.last_match
        start_pos = match_data.begin(0)

        if match_data[:url]
          url = clean_url(match_data[:url])
          is_obsidian = url.start_with?("obsidian://")
          links << { start: start_pos, length: url.length, text: url, href: url, obsidian: is_obsidian }
        else
          email = match_data[:email]
          links << { start: start_pos, length: email.length, text: email, href: "mailto:#{email}" }
        end
      end

      links
    end

    def clean_url(url)
      url.sub(TRAILING_PUNCTUATION_REGEXP, "")
    end
end
