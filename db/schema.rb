# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150206234715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bloques", force: :cascade do |t|
    t.string   "nombre",      limit: 100, null: false
    t.string   "descripcion", limit: 255
    t.string   "tipo",        limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "bloques_instrumentos", id: false, force: :cascade do |t|
    t.integer "bloque_id",      null: false
    t.integer "instrumento_id", null: false
  end

  create_table "bloques_preguntas", id: false, force: :cascade do |t|
    t.integer "bloque_id",   null: false
    t.integer "pregunta_id", null: false
  end

  create_table "carreras", force: :cascade do |t|
    t.string   "codigo",          limit: 10,  null: false
    t.string   "nombre",          limit: 255, null: false
    t.string   "organizacion_id", limit: 10,  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "carreras", ["codigo"], name: "index_carreras_on_codigo", using: :btree

  create_table "consultas", force: :cascade do |t|
    t.integer  "oferta_academica_id"
    t.integer  "instrumento_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "consultas", ["instrumento_id"], name: "index_consultas_on_instrumento_id", using: :btree
  add_index "consultas", ["oferta_academica_id"], name: "index_consultas_on_oferta_academica_id", using: :btree

  create_table "control_consultas", id: false, force: :cascade do |t|
    t.integer "estudiante_id",                       null: false
    t.integer "oferta_academica_id",                 null: false
    t.boolean "respondida",          default: false
  end

  create_table "docentes", force: :cascade do |t|
    t.string   "cedula",           limit: 20
    t.string   "primer_nombre",    limit: 45, null: false
    t.string   "segundo_nombre",   limit: 45
    t.string   "primer_apellido",  limit: 45, null: false
    t.string   "segundo_apellido", limit: 45
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "docentes", ["cedula"], name: "index_docentes_on_cedula", using: :btree

  create_table "estudiantes", force: :cascade do |t|
    t.string   "cedula",           limit: 20
    t.string   "primer_nombre",    limit: 45, null: false
    t.string   "segundo_nombre",   limit: 45
    t.string   "primer_apellido",  limit: 45, null: false
    t.string   "segundo_apellido", limit: 45
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "estudiantes", ["cedula"], name: "index_estudiantes_on_cedula", using: :btree

  create_table "instrumentos", force: :cascade do |t|
    t.string   "nombre",      limit: 100, null: false
    t.string   "descripcion", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "materias", force: :cascade do |t|
    t.string   "codigo",          limit: 10,  null: false
    t.integer  "carrera_id"
    t.string   "plan_nombre",     limit: 20,  null: false
    t.string   "nombre",          limit: 255, null: false
    t.string   "tipo_materia_id", limit: 10,  null: false
    t.string   "grupo_nota_id",   limit: 10,  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "materias", ["carrera_id"], name: "index_materias_on_carrera_id", using: :btree
  add_index "materias", ["codigo"], name: "index_materias_on_codigo", using: :btree

  create_table "oferta_academica", force: :cascade do |t|
    t.integer  "oferta_periodo_id"
    t.string   "nombre_seccion",               limit: 10, null: false
    t.integer  "docente_id"
    t.string   "promedio_general",             limit: 45
    t.integer  "nro_estudiantes"
    t.integer  "nro_estudiantes_retirados"
    t.integer  "nro_estudiantes_aprobados"
    t.integer  "nro_estudiantes_equivalencia"
    t.integer  "nro_estudiantes_suficiencia"
    t.integer  "nro_estudiantes_reparacion"
    t.integer  "nro_estudiantes_aplazados"
    t.string   "tipo_estatus_calificacion_id", limit: 10
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "oferta_academica", ["docente_id"], name: "index_oferta_academica_on_docente_id", using: :btree
  add_index "oferta_academica", ["oferta_periodo_id"], name: "index_oferta_academica_on_oferta_periodo_id", using: :btree

  create_table "ofertas_periodo", force: :cascade do |t|
    t.integer  "materia_id"
    t.integer  "periodo_academico_id"
    t.integer  "docente_coordinador"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "ofertas_periodo", ["materia_id"], name: "index_ofertas_periodo_on_materia_id", using: :btree
  add_index "ofertas_periodo", ["periodo_academico_id"], name: "index_ofertas_periodo_on_periodo_academico_id", using: :btree

  create_table "opciones", force: :cascade do |t|
    t.string   "etiqueta",    limit: 100, null: false
    t.string   "valor",       limit: 20,  null: false
    t.integer  "pregunta_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "opciones", ["pregunta_id"], name: "index_opciones_on_pregunta_id", using: :btree

  create_table "periodos_academicos", force: :cascade do |t|
    t.string   "periodo",        limit: 10,  null: false
    t.string   "hash_sum",       limit: 255
    t.datetime "sincronizacion"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "periodos_academicos", ["periodo"], name: "index_periodos_academicos_on_periodo", using: :btree

  create_table "preguntas", force: :cascade do |t|
    t.string   "interrogante",     limit: 100, null: false
    t.string   "descripcion",      limit: 255
    t.integer  "tipo_pregunta_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "preguntas", ["tipo_pregunta_id"], name: "index_preguntas_on_tipo_pregunta_id", using: :btree

  create_table "respuestas", force: :cascade do |t|
    t.integer  "consulta_id"
    t.integer  "pregunta_id"
    t.string   "valor",       limit: 45, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "respuestas", ["consulta_id"], name: "index_respuestas_on_consulta_id", using: :btree
  add_index "respuestas", ["pregunta_id"], name: "index_respuestas_on_pregunta_id", using: :btree

  create_table "tipos_pregunta", force: :cascade do |t|
    t.string   "nombre",     limit: 45, null: false
    t.string   "valor",      limit: 45, null: false
    t.string   "valor_html", limit: 45, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "token",      limit: 45,  null: false
    t.string   "hash_sum",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "consultas", "instrumentos"
  add_foreign_key "consultas", "oferta_academica"
  add_foreign_key "materias", "carreras"
  add_foreign_key "oferta_academica", "docentes"
  add_foreign_key "oferta_academica", "ofertas_periodo"
  add_foreign_key "ofertas_periodo", "materias"
  add_foreign_key "ofertas_periodo", "periodos_academicos"
  add_foreign_key "opciones", "preguntas"
  add_foreign_key "preguntas", "tipos_pregunta"
  add_foreign_key "respuestas", "consultas"
  add_foreign_key "respuestas", "preguntas"
end
