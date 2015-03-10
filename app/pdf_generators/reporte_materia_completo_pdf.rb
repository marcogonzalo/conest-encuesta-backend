class ReporteMateriaCompletoPdf < PdfGenerator
	def initialize(materia,instrumento,resultados,titulo = nil)
		super()
		@materia = materia
		@instrumento = instrumento
		@resultados = resultados
		@titulo = titulo
		content
		repeat (:all) do
			header
			footer
		end
	end

	def content
		grid([2,0],[19,11]).bounding_box do
			text @materia.nombre, size: 15, style: :bold, align: :center
			text @instrumento.nombre, size: 15, style: :bold, align: :center
			text(@titulo, size: 15, style: :bold, align: :center) unless @titulo.nil?
			@instrumento.bloques.each do |b|
				puts b.inspect
				puts b.preguntas.inspect
				if b.preguntas.size > 0
					move_down 25
					text b.nombre, size: 15, style: :bold, align: :center
					b.preguntas.each do |p|
						text_content(p.interrogante)
						if @resultados[p.id]
							tabla_de_datos(p.opciones,@resultados[p.id])
						else
							text "No se registraron respuestas para esta pregunta", size: 12, style: :normal, align: :center
						end
					end
				end
			end
		end
	end

	protected
	def text_content(interrogante)
		# The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
		# y_position = cursor - 50
		move_down 15
		text interrogante, size: 14, style: :normal
		move_down 5
		# The bounding_box takes the x and y coordinates for positioning its content and some options to style it
		# bounding_box([300, y_position], :width => 270, :height => 300) do
		# 	text "Duis vel", size: 15, style: :bold
		# 	text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
		# end
	end
end
