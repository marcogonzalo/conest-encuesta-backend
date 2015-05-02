class PdfGenerator < Prawn::Document
	TABLE_ROW_COLORS = ['EEEEEE', 'FFFFFF']
	TABLE_BORDER_STYLE = :grid
	TABLE_FONT_SIZE = 9
	TABLE_TEXT_ALIGN = :center
	AZUL_CIENCIAS = '38637B' # Sugerido por ciens.ucv.ve. Según manual de marca es: 00669E 

	def initialize(default_prawn_options={})
		super(default_prawn_options)
		font_size 10
		define_grid(columns: 12, rows: 20, gutter: 10)
	end

	def header
		grid([0,0],[1,11]).bounding_box do
			image "#{Rails.root}/public/logo_ucv.jpg", height: 50, :at => [bounds.left, bounds.top]
			image "#{Rails.root}/public/logociens.jpg", height: 50, :at => [bounds.right-50, bounds.top]
			text "UNIVERSIDAD CENTRAL DE VENEZUELA", size: 16, style: :bold, align: :center
			text "FACULTAD DE CIENCIAS", size: 16, style: :bold, align: :center
			#text "DIVISIÓN DE CONTROL DE ESTUDIOS", size: 16, style: :bold, align: :center
			move_down 15
			hr
			move_down 10
		end
	end

	def titulo(elemento, instrumento, titulo)
		text instrumento, size: 15, style: :bold, align: :center unless instrumento.nil?
		text(titulo, size: 15, style: :bold, align: :center) unless titulo.nil?
		text elemento, size: 15, style: :bold, align: :center  unless elemento.nil?
	end

	def footer
		bounding_box([bounds.left, bounds.bottom], :width => bounds.width, :height => 100) do
			hr
			y_position = cursor
			opciones_fecha = {
				:at => [bounds.left,y_position],
				:width => 150,
				:align => :left,
				:page_filter => :all,
				:size => 8
			}
			number_pages "Fecha #{Time.now.to_s}", opciones_fecha

			string = "página <page> de <total>"
			opciones_paginacion = {
				:at => [bounds.right-150,y_position],
				:width => 150,
				:align => :right,
				:page_filter => :all,
				:size => 8
			}
			number_pages string, opciones_paginacion
		end
	end

	def hr
		stroke_color AZUL_CIENCIAS
		stroke do
			move_down 5
			horizontal_rule
			self.line_width = 2
			move_down 5
		end
	end


	def tabla_de_datos(param_opciones,param_resultados,tipo)
		# This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
		# I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
		# Then I set the table column widths
		case tipo
		when :materia
			table result_rows_materia(param_opciones,param_resultados) do
				self.header = true
				self.row_colors = TABLE_ROW_COLORS.reverse
				self.cell_style = {align: :center, size: 10}
				self.position = :center
				row(0).font_style = :bold
				row(0).valign = :top
				row(1).font_style = :bold
				row(1).valign = :top
			end
		when :docente
			table result_rows_docente(param_opciones,param_resultados) do
				self.header = true
				self.row_colors = TABLE_ROW_COLORS.reverse
				self.cell_style = {align: :center, size: 10}
				self.position = :center
				row(0).font_style = :bold
				row(0).valign = :top
				row(1).font_style = :bold
				row(1).valign = :top
			end
		end
	end

	def result_rows_materia(param_opciones,param_resultados)
		# Arreglo de opciones para cabecera
		opciones = []
		param_opciones.each do |o|
			opciones.push(o.valor)
		end

		# Títulos de las columnas para cabecera 
		titulos = [{content: '#', rowspan: 2}, {content: 'Período', rowspan: 2}, {content: "Materia", rowspan: 2}, {content: 'Sección', rowspan: 2}, {content: 'Opciones', colspan: opciones.count}, {content: "Respuestas", rowspan: 2}, {content: "Inscritos", rowspan: 2}, {content: "Participación", rowspan: 2}, {content: "Media", rowspan: 2}]
		
		# Junto los títulos y opciones como la cabecera
		data = [titulos]+[opciones]

		i = 0
		param_resultados.map do |periodo,secciones|
			secciones.each do |s,info|
				valores = {}
				info['totalizacion'].each do |valor, total|
					valores[valor] = total
				end

				datos = {}
				info['datos'].each do |clave, valor|
					datos[clave] = valor
				end
				participacion = (datos["total_respuestas"].to_f/datos["total_estudiantes"].to_f).round(2)
				arreglo_valores = []
				opciones.each do |o|
					arreglo_valores.push(valores[o])
				end
				data += [[i+=1,periodo,s,@materia.codigo]+arreglo_valores+[datos["total_respuestas"],datos["total_estudiantes"],participacion,datos["media_de_seccion"]]]
			end
		end
		return data
	end	

	def result_rows_docente(param_opciones,param_resultados)
		# Arreglo de opciones para cabecera
		opciones = []
		param_opciones.each do |o|
			opciones.push(o.valor)
		end

		# Títulos de las columnas para cabecera 
		titulos = [{content: '#', rowspan: 2}, {content: 'Período', rowspan: 2}, {content: 'Sección', rowspan: 2}, {content: "Código", rowspan: 2}, {content: 'Opciones', colspan: opciones.count}, {content: "Respuestas", rowspan: 2}, {content: "Inscritos", rowspan: 2}, {content: "Participación", rowspan: 2}, {content: "Media", rowspan: 2}]
		
		# Junto los títulos y opciones como la cabecera
		data = [titulos]+[opciones]

		i = 0
		param_resultados.map do |periodo,materias|
			materias.each do |m,secciones|
				secciones.each do |s,info|
					valores = {}
					info['totalizacion'].each do |valor, total|
						valores[valor] = total
					end

					datos = {}
					info['datos'].each do |clave, valor|
						datos[clave] = valor
					end
					participacion = (datos["total_respuestas"].to_f/datos["total_estudiantes"].to_f).round(2)
					arreglo_valores = []
					opciones.each do |o|
						arreglo_valores.push(valores[o])
					end
					data += [[i+=1,periodo,m,s]+arreglo_valores+[datos["total_respuestas"],datos["total_estudiantes"],participacion,datos["media_de_seccion"]]]
				end
			end
		end
		return data
	end
end