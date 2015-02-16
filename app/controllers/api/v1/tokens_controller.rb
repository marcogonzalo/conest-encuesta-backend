module Api
  module V1
    class TokensController < ApplicationController
      before_action :set_token, only: [:show, :destroy]

      # GET /tokens
      # GET /tokens.json
      def index
        @tokens = Token.all
      end

      # GET /tokens/1
      # GET /tokens/1.json
      def show
      end

      # POST /tokens
      # POST /tokens.json
      def create
        begin
          response = RestClient.post "#{CONEST_API[:base_url]}/autenticar",
                      :app_id   =>  CONEST_API[:app_id],
                      :clave    =>  CONEST_API[:clave]

          respuesta = JSON.parse(response.body)
          if respuesta['estatus'] == 'OK'
            @token = Token.new(token: respuesta['datos']['token'], hash_sum: respuesta['sha1_sum'])
          end

          respond_to do |format|
            if respuesta['estatus'] == 'OK' and @token.save
              format.html { redirect_to @token, notice: 'Token was successfully created.' }
              format.json { render :show, status: :created, location: api_v1_token_url(@token) }
            else
              if respuesta['estatus'] == 'OK'
                format.html { render :new }
                format.json { render json: @token.errors, status: :unprocessable_entity }
              else
                format.html { render :new }
                format.json { render json: respuesta['mensaje'], status: :unprocessable_entity }
              end
            end
          end
        rescue => e
          e
        end
      end

      # DELETE /tokens/1
      # DELETE /tokens/1.json
      def destroy
        @token.destroy
        respond_to do |format|
          format.html { redirect_to api_v1_tokens_url, notice: 'Token was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_token
          @token = Token.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def token_params
          params.require(:token).permit(:token, :hash_sum)
        end
    end
  end
end
