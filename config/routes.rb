Rails.application.routes.draw do

  namespace :api, except: [:new, :edit], defaults: {format: :json} do
    namespace :v1 do
      post '/auth' => 'auth#authenticate'

      resources :consultas do
        member do
          post '/responder' => 'consultas#responder', as: 'responder_consulta'
        end
      end

      scope '/reportes/:tipo_reporte' do
        # Reportes por materia
        scope '/materias/:codigo_materia' do
          # Reportes historicos
          get '/preguntas/:pregunta_id(.:format)' => 'reportes#reporte_historico_pregunta_de_materia', as: 'generar_reporte_historico_pregunta_de_materia', constraints: { tipo_reporte: /historico_pregunta/ }
          get '/instrumentos/:instrumento_id(.:format)' => 'reportes#reporte_historico_completo_de_materia', as: 'generar_reporte_historico_completo_de_materia', constraints: { tipo_reporte: /historico_completo/ }
          get '/instrumentos/:instrumento_id(.:format)' => 'reportes#reporte_historico_comparado_de_materia', as: 'generar_reporte_historico_comparado_de_materia', constraints: { tipo_reporte: /historico_comparado/ }

          # Reportes de periodo
          get '/periodos/:periodo(.:format)' => 'reportes#reporte_periodo_completo_de_materia', as: 'generar_reporte_periodo_completo_de_materia', constraints: { tipo_reporte: /periodo_completo/ }
          get '/periodos/:periodo(.:format)' => 'reportes#reporte_periodo_comparado_de_materia', as: 'generar_reporte_periodo_comparado_de_materia', constraints: { tipo_reporte: /periodo_comparado/ }
        end

        # Reportes por materia
        scope '/docentes/:cedula_docente' do
          # Reportes historicos
          get '/preguntas/:pregunta_id(.:format)' => 'reportes#reporte_historico_pregunta_de_docente', as: 'generar_reporte_historico_pregunta_de_docente', constraints: { tipo_reporte: /historico_pregunta/ }
          get '/instrumentos/:instrumento_id(.:format)' => 'reportes#reporte_historico_completo_de_docente', as: 'generar_reporte_historico_completo_de_docente', constraints: { tipo_reporte: /historico_completo/ }
          get '/instrumentos/:instrumento_id(.:format)' => 'reportes#reporte_historico_comparado_de_docente', as: 'generar_reporte_historico_comparado_de_docente', constraints: { tipo_reporte: /historico_comparado/ }
          
          # Reportes de periodo
          get '/periodos/:periodo(.:format)' => 'reportes#reporte_periodo_completo_de_docente', as: 'generar_reporte_periodo_completo_de_docente', constraints: { tipo_reporte: /periodo_completo/ }
          get '/periodos/:periodo(.:format)' => 'reportes#reporte_periodo_comparado_de_docente', as: 'generar_reporte_periodo_comparado_de_docente', constraints: { tipo_reporte: /periodo_comparado/ }
        end
      end
      
      # Rutas asociadas a elementos de Conest
      resources :periodos_academicos do
        resources :ofertas_periodo
      end
      get '/periodos_academicos/:periodo/sincronizar_estudiantes' => 'periodos_academicos#sincronizar_estudiantes', as: 'sincronizar_estudiantes_de_periodo'

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
      
      resources :roles, except: [:create, :delete]

      get '/usuario_puede/:nombre_permiso' => 'permisos#puede'

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
