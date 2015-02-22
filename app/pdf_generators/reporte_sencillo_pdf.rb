class ReporteSencilloPdf < PdfGenerator
	def initialize(materia,pregunta,resultados)
		super()
		@materia = materia
		@pregunta = pregunta
		@resultados = resultados
		header
		text_content
		table_content
		footer
	end

	protected
	def text_content
		# The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
		# y_position = cursor - 50

		move_down 50
		text @pregunta.interrogante, size: 15, style: :bold, align: :center
		hr
		# The bounding_box takes the x and y coordinates for positioning its content and some options to style it
		# bounding_box([300, y_position], :width => 270, :height => 300) do
		# 	text "Duis vel", size: 15, style: :bold
		# 	text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
		# end
	end

	def table_content
		# This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
		# I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
		# Then I set the table column widths
		table result_rows do
			self.header = true
			self.row_colors = TABLE_ROW_COLORS
			self.cell_style = {align: :center, size: 10}
			self.position = :center
			# self.column_widths = [40, 300, 200]
			row(0).font_style = :bold
		end
	end

	def result_rows
		data = [['#', 'Período', 'Sección', "Código","1","2","3","4","5","Respuestas","Inscritos","Participación"]]
		i = 0
		@resultados.map do |periodo,secciones|
			secciones.each do |s,info|
				valores = {"1" => 0, "2" => 0, "3" => 0, "4" => 0, "5" => 0}
				info['totalizacion'].each do |valor, total|
					valores[valor] = total
				end

				datos ||= {}
				info['datos'].each do |clave, valor|
					datos[clave] = valor
				end
				participacion = (datos["total_respuestas"].to_f/datos["total_estudiantes"].to_f).round(2)
				data += [[i+=1,periodo,s,@materia.codigo,valores["1"],valores["2"],valores["3"],valores["4"],valores["5"],datos["total_respuestas"],datos["total_estudiantes"],participacion]]
			end
		end
		return data
	end
end
