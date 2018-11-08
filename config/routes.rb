Rails.application.routes.draw do
  root 'movie#search'
  post '/', to: 'movie#result'
end
