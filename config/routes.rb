SmartAnswers::Application.routes.draw do
  match '/calculate-your-annual-leave', :to => 'holiday_pay#index', :as => :holiday_pay

  match '/:id(/:started(/*responses)).:format',
    :to => 'smart_answers#show',
    :as => :formatted_smart_answer,
    :constraints => { :format => /[a-zA-Z]+/ }

  match '/:id(/:started(/*responses))', :to => 'smart_answers#show', :as => :smart_answer
end
