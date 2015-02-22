class PdfGenerator < Prawn::Document
	TABLE_ROW_COLORS = ['EEEEEE', 'FFFFFF']
	TABLE_BORDER_STYLE = :grid
	TABLE_FONT_SIZE = 9
	TABLE_TEXT_ALIGN = :center
	AZUL_CIENCIAS = '38637B' # Sugerido por ciens.ucv.ve. Según manual de marca es: 00669E 

	def initialize(default_prawn_options={})
		super(default_prawn_options)
		font_size 10
	end

	def header
		y_position = cursor
		image "#{Rails.root}/public/logo_ucv.jpg", height: 50, :at => [0, y_position]
		image "#{Rails.root}/public/logociens.jpg", height: 50, :at => [bounds.right-50, y_position]
		text "UNIVERSIDAD CENTRAL DE VENEZUELA", size: 16, style: :bold, align: :center
		text "FACULTAD DE CIENCIAS", size: 16, style: :bold, align: :center
		text "DIVISIÓN DE CONTROL DE ESTUDIOS", size: 16, style: :bold, align: :center
		hr
	end

	def footer
		# The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
		# y_position = cursor - 50

		# The bounding_box takes the x and y coordinates for positioning its content and some options to style it
		bounding_box([bounds.left, bounds.bottom], :width => bounds.right-bounds.left, :height => 100) do
		# 	text "Duis vel", size: 15, style: :bold
		# 	text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
			hr
		end
	end

	def hr
		stroke_color AZUL_CIENCIAS
		stroke do
			move_down 10
			horizontal_rule
			move_down 10
			self.line_width = 2
		end
	end
end