class CarrerasController < ApplicationController
  before_action :set_carrera, only: [:show, :edit, :update, :destroy]
  before_action :set_facultades, only: [:new, :edit, :create, :update]
  layout "prueba"

  # GET /carreras
  def index
    @carreras = Carrera.all.order(:nombrecarrera)
    @carrera = Carrera.new
  end

  # GET /carreras/1
  def show
  end

  # GET /carreras/new
  def new
    @carrera = Carrera.new
  end

  # GET /carreras/1/edit
  def edit
  end

  # POST /carreras
  def create
    @carrera = Carrera.new(carrera_params)

    if @carrera.save
      redirect_to carreras_path, notice: 'Carrera creada exitosamente.'
    else
      flash.now[:alert] = 'Error al crear la carrera. Verifique los datos.'
      render :new
    end
  end

  # PATCH/PUT /carreras/1
  def update
    if @carrera.update(carrera_params)
      redirect_to @carrera, notice: 'Carrera actualizada exitosamente.'
    else
      flash.now[:alert] = 'Error al actualizar la carrera. Verifique los datos.'
      render :edit
    end
  end

  # DELETE /carreras/1
  def destroy
    if @carrera.update(estado: false)
      redirect_to carreras_path, notice: 'Carrera desactivada exitosamente.'
    else
      redirect_to carreras_path, alert: 'Error al desactivar la carrera.'
    end
  end

  private

  def set_carrera
    @carrera = Carrera.find(params[:id])
  end

  def set_facultades
    @facultades = Facultad.all.order(:nombrefacultad)
  end

  def carrera_params
    params.require(:carrera).permit(:nombrecarrera, :codigo, :facultad_id, :estado)
  end
end