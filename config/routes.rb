Rails.application.routes.draw do
  post 'events', to: 'events#handle_event'
  get 'files/ivr_menu', to: 'files#ivr_menu'
end
