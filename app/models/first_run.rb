class FirstRun
  def self.create!(user_attributes)
    Account.create!(name: "Fizzy")
    User.member.create!(user_attributes)
    Closure::Reason.create_defaults
  end
end
