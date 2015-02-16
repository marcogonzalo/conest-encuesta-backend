Rails.application.routes.draw do
  namespace :api, except: [:new, :edit], defaults: {format: :json} do
    namespace :v1 do

      resources :consultas

      # Rutas asociadas a elementos de Conest
      resources :periodos_academicos do
        resources :ofertas_periodo
      end
      post '/periodos_academicos/:periodo/sincronizar_estudiantes' => 'periodos_academicos#sincronizar_estudiantes', as: 'sincronizar_estudiantes_de_periodo'

      resources :carreras, shallow: true do
        resources :materias
      end

      resources :oferta_academica

      resources :docentes
      resources :estudiantes do
        member do
          get '/consultas_sin_responder' => 'estudiantes#consultas_sin_responder', as: 'consultas_sin_responder'
        end
      end

      # Rutas asociadas  a componentes del SEDAD
      resources :instrumentos
      resources :bloques

      # Rutas asociadas a preguntas, opciones y respuestas
      resources :tipos_pregunta
      resources :preguntas do
        resources :opciones
      end
      resources :respuestas, except: [:update, :delete]

      resources :tokens, except: [:show]
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
