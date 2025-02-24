require "test_helper"

class NotifierTest < ActiveSupport::TestCase
  test "for returns the matching notifier class for the event" do
    assert_kind_of Notifier::Published, Notifier.for(events(:logo_published))
  end

  test "for does not raise an error when the event is not notifiable" do
    assert_nothing_raised do
      assert_no_difference -> { Notification.count } do
        Notifier.for(events(:logo_boost_dhh))
      end
    end
  end

  test "generate does not create notifications if the event was system-generated" do
    bubbles(:logo).drafted!
    events(:logo_published).update!(creator: accounts("37s").users.system)

    assert_no_difference -> { Notification.count } do
      Notifier.for(events(:logo_published)).generate
    end
  end

  test "creates a notification for each watcher, other than the event creator" do
    notifications = Notifier.for(events(:logo_published)).generate

    assert_equal users(:kevin, :jz).sort, notifications.map(&:user).sort
  end

  test "links to the bubble" do
    Notifier.for(events(:logo_published)).generate

    assert_equal bubbles(:logo), Notification.last.resource
  end
end
