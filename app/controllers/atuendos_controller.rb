class AtuendosController < ApplicationController

    before_action :set_guardarropa
    helper_method :ordenar_columna,:ordenar_direccion
    
    def index
        if(@guardarropa)
            @atuendos=Atuendo.where(guardarropa_id: @guardarropa.id).order(ordenar_columna + " " + ordenar_direccion)
            
            if(params[:estilo] || params[:estacion])
                @atuendos=Atuendo.all
                @atuendos=@atuendos.where(estilo: params[:estilo]) if(params[:estilo] != "")
                @atuendos=@atuendos.where(estacion: params[:estacion]) if(params[:estacion] != "")
            end
        end
        
    end

    def show
        @atuendo= Atuendo.find_by(id: params[:id].to_i, usuario_id: current_usuario.id)
    end    
    
    def destroy
        aId=Atuendo.find(params[:id].to_i).id
        @atuendo= Atuendo.find(params[:id].to_i)
        if @atuendo.destroy
            redirect_to guardarropa_atuendos_path(:guardarropa_id => @guardarropa.id), notice: t(:deleted)
        end
    end 

    def show_random

        @atuendo=Atuendo.new
        @prenda_cabeza=  Guardarropa.find(params[:guardarropa_id]).prendas.joins(:prenda_tipo).where(prenda_tipos: {categoria: :cabeza}).order('RANDOM()').first
        @prenda_torso=   Guardarropa.find(params[:guardarropa_id]).prendas.joins(:prenda_tipo).where(prenda_tipos: {categoria: :torso}).order('RANDOM()').first
        @prenda_piernas= Guardarropa.find(params[:guardarropa_id]).prendas.joins(:prenda_tipo).where(prenda_tipos: {categoria: :piernas}).order('RANDOM()').first
        @prenda_pies=    Guardarropa.find(params[:guardarropa_id]).prendas.joins(:prenda_tipo).where(prenda_tipos: {categoria: :pies}).order('RANDOM()').first
        
    end

    def new
        @atuendo=Atuendo.new
    end

    def create
        @atuendo=Atuendo.new(atuendo_params)
        @atuendo.usuario=current_usuario

        if (@guardarropa.atuendos << @atuendo)
        redirect_to guardarropa_atuendos_path,notice: t(:created)  
        end
    end

    def edit
        @atuendo= Atuendo.find(params[:id].to_i)
    end

    def update
        @atuendo= Atuendo.find(params[:id].to_i)
        if @atuendo.update_attributes(atuendo_params)
            redirect_to guardarropa_atuendos_path, notice: t(:updated)
        else
            render edit_atuendo_path
        end
    end

    private
    def atuendo_params
       params.require(:atuendo).permit(:prenda_cabeza_id, :prenda_torso_id, :prenda_piernas_id, :prenda_pies_id, :puntaje, :estilo, :estacion)     
    end

    def set_atuendo
        @atuendo= Atuendo.find(params[:id].to_i)
    end

    def set_guardarropa
        @guardarropa= Guardarropa.find_by(id: params[:guardarropa_id].to_i, usuario_id: current_usuario.id)
    end

    def ordenar_columna
        Atuendo.column_names.include?(params[:columna]) ? params[:columna] : "puntaje"
    end

    def ordenar_direccion
        %w[asc desc].include?(params[:direccion]) ? params[:direccion] : "desc"
    end

end