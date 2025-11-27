Fizzy::Saas::Engine.routes.draw do
  get "/signup/new", to: redirect("/session/new")

  Queenbee.routes(self)
end
