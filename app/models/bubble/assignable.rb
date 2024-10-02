module Bubble::Assignable
  extend ActiveSupport::Concern

  included do
    has_many :assignments, dependent: :destroy

    has_many :assignees, through: :assignments
    has_many :assigners, through: :assignments
  end
end
