class FacultadsController < ApplicationController
  layout "prueba"
  before_action :authenticate_user!
  before_action :set_facultad, only: [:show, :edit, :update, :destroy]

  # GET /facultads
  def index
    @facultades = Facultad.all.order(:nombrefacultad)
    @facultad = Facultad.new
  end

  # GET /facultads/1
  def show
    # @facultad is set by before_action
  end

  # GET /facultads/new
  def new
    @facultad = Facultad.new
  end

  # GET /facultads/1/edit
  def edit
    # @facultad is set by before_action
  end

  # POST /facultads
  def create
    @facultad = Facultad.new(facultad_params)

    respond_to do |format|
      if @facultad.save
        format.html { redirect_to facultads_path, success: 'Facultad creada exitosamente.' }
        format.json { render :show, status: :created, location: @facultad }
      else
        format.html { render :new }
        format.json { render json: @facultad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facultads/1
  def update
    respond_to do |format|
      if @facultad.update(facultad_params)
        format.html { redirect_to @facultad, success: 'Facultad actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @facultad }
      else
        format.html { render :edit }
        format.json { render json: @facultad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facultads/1
  def destroy
    if @facultad.update(estado: false)
      redirect_to facultads_path, success: 'Facultad desactivada exitosamente.'
    else
      redirect_to facultads_path, danger: 'No se pudo desactivar la facultad.'
    end
  end

  private

  def set_facultad
    @facultad = Facultad.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to facultads_path, danger: 'Facultad no encontrada.'
  end

  def facultad_params
    params.require(:facultad).permit(:nombrefacultad, :estado)
  end
end