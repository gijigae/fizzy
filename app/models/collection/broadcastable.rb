module Collection::Broadcastable
  extend ActiveSupport::Concern

  included do
    broadcasts_refreshes
    broadcasts_refreshes_to ->(collection) { :collections }
  end
end
