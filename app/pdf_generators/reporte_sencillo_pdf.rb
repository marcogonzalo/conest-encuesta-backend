class ReporteSencilloPdf < PdfGenerator
	def initialize(materia,pregunta,resultados)
		super()
		@materia = materia
		@pregunta = pregunta
		@opciones = pregunta.opciones
		@resultados = resultados
		content
		repeat (:all) do
			header
			footer
		end
	end

	def content
		grid([2,0],[19,11]).bounding_box do
			text_content
			table_content(@pregunta.opciones,@resultados)
		end
	end

	protected
	def text_content
		# The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
		# y_position = cursor - 50
		text @materia.nombre, size: 15, style: :bold, align: :center
		text @pregunta.interrogante, size: 14, style: :normal, align: :center
		move_down 5
		# The bounding_box takes the x and y coordinates for positioning its content and some options to style it
		# bounding_box([300, y_position], :width => 270, :height => 300) do
		# 	text "Duis vel", size: 15, style: :bold
		# 	text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
		# end
	end
end
