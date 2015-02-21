class ReporteSencilloPdfGenerator < Prawn::Document
	def initialize(materia,pregunta,resultados)
		super()
		@materia = materia
		@pregunta = pregunta
		@resultados = resultados
		header
		text_content
		table_content
	end

	def header
		#This inserts an image in the pdf file and sets the size of the image
		image "#{Rails.root}/app/assets/images/logo_conest.png" #, width: 530, height: 150
	end

	def text_content
		# The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
		# y_position = cursor - 50

		text @pregunta.interrogante, size: 15, style: :bold
		
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
			row(0).font_style = :bold
			self.row_colors = ['EEEEEE', 'FFFFFF']
			# self.column_widths = [40, 300, 200]
		end
	end

	def result_rows
		data = [['#', 'Período', 'Sección', "Código","1","2","3","4","5","Participantes","Total Estudiantes"]]
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

				data = data + [['#',periodo,s,@materia.codigo,valores["1"],valores["2"],valores["3"],valores["4"],valores["5"],datos["total_respuestas"],datos["total_estudiantes"]]]
			end
		end
		return data
	end
end
