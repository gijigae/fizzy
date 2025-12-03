require "test_helper"

class HtmlHelperTest < ActionView::TestCase
  test "convert URLs into anchor tags" do
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a></p>),
      format_html("<p>Check this: https://example.com</p>")
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com/" rel="noreferrer">https://example.com/</a></p>),
      format_html("<p>Check this: https://example.com/</p>")
  end

  test "don't' include punctuation in URL autolinking" do
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a>!</p>),
      format_html("<p>Check this: https://example.com!</p>")
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a>.</p>),
      format_html("<p>Check this: https://example.com.</p>")
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a>?</p>),
      format_html("<p>Check this: https://example.com?</p>")
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a>,</p>),
      format_html("<p>Check this: https://example.com,</p>")
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a>:</p>),
      format_html("<p>Check this: https://example.com:</p>")
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com" rel="noreferrer">https://example.com</a>;</p>),
      format_html("<p>Check this: https://example.com;</p>")
  end

  test "respect existing links" do
    assert_equal_html \
      %(<p>Check this: <a href="https://example.com">https://example.com</a></p>),
      format_html("<p>Check this: <a href=\"https://example.com\">https://example.com</a></p>")
  end

  test "convert email addresses into mailto links" do
    assert_equal_html \
      %(<p>Contact us at <a href="mailto:support@example.com">support@example.com</a></p>),
      format_html("<p>Contact us at support@example.com</p>")
  end

  test "respect existing linked emails" do
    assert_equal_html \
      %(<p>Contact us at <a href="mailto:support@example.com">support@example.com</a></p>),
      format_html(%(<p>Contact us at <a href="mailto:support@example.com">support@example.com</a></p>))
  end

  test "don't autolink content in excluded elements" do
    %w[ figcaption pre code ].each do |element|
      assert_equal_html \
        "<#{element}>Check this: https://example.com</#{element}>",
        format_html("<#{element}>Check this: https://example.com</#{element}>")
    end
  end

  test "convert Obsidian URLs into anchor tags" do
    assert_equal_html \
      %(<p>Open in Obsidian: <a href="obsidian://open?vault=notes&amp;file=test">obsidian://open?vault=notes&amp;file=test</a></p>),
      format_html("<p>Open in Obsidian: obsidian://open?vault=notes&file=test</p>")
  end

  test "convert Obsidian URLs with encoded paths into anchor tags" do
    assert_equal_html \
      %(<p>Check: <a href="obsidian://open?vault=obs&amp;file=Cursor%2Fanzennow%2F2025-12-03-url-search-params-sync-pattern">obsidian://open?vault=obs&amp;file=Cursor%2Fanzennow%2F2025-12-03-url-search-params-sync-pattern</a></p>),
      format_html("<p>Check: obsidian://open?vault=obs&file=Cursor%2Fanzennow%2F2025-12-03-url-search-params-sync-pattern</p>")
  end

  test "don't include punctuation in Obsidian URL autolinking" do
    assert_equal_html \
      %(<p>Check this: <a href="obsidian://open?vault=notes&amp;file=test">obsidian://open?vault=notes&amp;file=test</a>.</p>),
      format_html("<p>Check this: obsidian://open?vault=notes&file=test.</p>")
  end

  test "respect existing Obsidian links" do
    assert_equal_html \
      %(<p>Check this: <a href="obsidian://open?vault=notes&amp;file=test">Open in Obsidian</a></p>),
      format_html(%(<p>Check this: <a href="obsidian://open?vault=notes&amp;file=test">Open in Obsidian</a></p>))
  end

  test "unwrap empty anchor tags and auto-link URLs inside them" do
    assert_equal_html \
      %(<p><a href="https://example.com" rel="noreferrer">https://example.com</a></p>),
      format_html(%(<p><a>https://example.com</a></p>))
  end

  test "unwrap empty anchor tags and auto-link Obsidian URLs inside them" do
    assert_equal_html \
      %(<p><a href="obsidian://open?vault=notes&amp;file=test">obsidian://open?vault=notes&amp;file=test</a></p>),
      format_html(%(<p><a>obsidian://open?vault=notes&file=test</a></p>))
  end
end
