FactoryGirl.define do
  factory :bloque do
    nombre "cualquiera"
    tipo { Bloque::TIPO.keys[Forgery(:basic).number(at_least: 0, at_most: Bloque::TIPO.keys.size-1)] }
  end

  factory :carrera do
    codigo { Forgery('basic').text(exactly: 6) }
    nombre  { |n| "Carrera #{n}" }
    organizacion_id Forgery('basic').number
  end

  factory :consulta do
    association :instrumento
    association :oferta_academica
  end

  factory :control_consulta do
    association :estudiante
    association :oferta_academica
  end

  factory :docente do
    cedula { Forgery(:basic).number(at_least: 10000000, at_most: 20000000) }
    primer_nombre "Pedro"
    primer_apellido  "Pérez"
  end

  factory :estudiante do
    cedula { Forgery(:basic).number(at_least: 15000000, at_most: 30000000) }
    primer_nombre "Pablo"
    primer_apellido  "Padrino"

    # user_with_posts will create post data after the user has been created
    factory :estudiante_con_consultas_por_responder do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        control_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |estudiante, evaluator|
        create_list(:control_consulta, evaluator.control_count, estudiante: estudiante)
      end
    end
  end

  factory :instrumento do
    nombre "cualquiera"
  end

  factory :materia do
    codigo { Forgery('basic').text(exactly: 6) }
    plan_nombre "Plan de Materia"
    nombre  { |n| "Materia #{n}" }
    tipo_materia_id { Materia::TIPO.keys[Forgery(:basic).number(at_least: 0, at_most: Materia::TIPO.keys.size-1)] }
    grupo_nota_id "Aprobado"

    association :carrera
  end

  factory :oferta_periodo do
    association :materia
    association :periodo_academico
    association :docente_coordinador, factory: :docente
  end

  factory :oferta_academica do
    association :oferta_periodo
    association :docente
    nombre_seccion { Forgery('basic').text(exactly: 2) }
  end

  factory :opcion do
    association :pregunta
    etiqueta { Forgery('basic').text(at_least: 2, at_most: 15) }
    valor { Forgery('basic').text(exactly: 2) }
  end

  factory :periodo_academico do
    periodo { Forgery('basic').text(exactly: 7) }
    asignaturas_hash_sum { |n| Forgery(:basic).encrypt n }
    sincronizacion { Forgery('date').date }
  end

  factory :pregunta do
    association :tipo_pregunta
    interrogante "interrogante" 
    descripcion "descripción"
  end

  factory :respuesta do
    association :consulta
    association :pregunta
    valor "valor"
  end

  factory :tipo_pregunta do
    nombre "tipo" 
    valor "valor"
    valor_html "valor_html"
  end

  factory :token do
    token "123"
    hash_sum { |n| Forgery(:basic).encrypt n }
  end
end