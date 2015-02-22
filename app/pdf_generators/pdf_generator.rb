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
			text "DIVISIÓN DE CONTROL DE ESTUDIOS", size: 16, style: :bold, align: :center
			hr
			move_down 10
		end
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
end