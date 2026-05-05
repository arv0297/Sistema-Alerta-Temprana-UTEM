class EstudiantesController < ApplicationController
  layout 'prueba'
  before_action :set_estudiante, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit, :update]
  before_action :authorize_admin!, only: [:new, :create, :edit, :update, :destroy]

  # GET /estudiantes
  def index
    @estudiantes = Estudiante.includes(:carrera, :user).order(:nombreestudiante)
    @users = User.all
  end

  # GET /estudiantes/1
  def show
    # @estudiante is set by before_action
  end

  # GET /estudiantes/new
  def new
    @estudiante = Estudiante.new
  end

  # GET /estudiantes/1/edit
  def edit
    # @estudiante is set by before_action
  end

  # POST /estudiantes
  def create
    @estudiante = Estudiante.new(estudiante_params)

    respond_to do |format|
      if @estudiante.save
        format.html { redirect_to @estudiante, success: 'Estudiante creado exitosamente.' }
        format.json { render :show, status: :created, location: @estudiante }
      else
        format.html { render :new }
        format.json { render json: @estudiante.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estudiantes/1
  def update
    respond_to do |format|
      if @estudiante.update(estudiante_params)
        format.html { redirect_to @estudiante, success: 'Estudiante actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @estudiante }
      else
        format.html { render :edit }
        format.json { render json: @estudiante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estudiantes/1
  def destroy
    if @estudiante.update(estado: false)
      redirect_to estudiantes_path, success: 'Estudiante desactivado exitosamente.'
    else
      redirect_to estudiantes_path, danger: 'No se pudo desactivar el estudiante.'
    end
  end

  private

  def set_estudiante
    @estudiante = Estudiante.find(params[:id])
  end

  def set_users
    @users = User.includes(:rol).where(estado: true)#.where(rols: { descripcion: 'Tutor' })
  end

  def estudiante_params
    params.require(:estudiante).permit(
      :nombreestudiante,
      :nem,
      :situacioneconomica,
      :colegio,
      :ranking,
      :carrera_id,
      :user_id,
      :fecha_nacimiento,
      :estado,
      :rut,
      :telefono,
      :email,
      :apellidopa,
      :apellidoma,
      :comuna,
      :direccion
    )
  end

  def authorize_admin!
    return if current_user&.rol&.descripcion == 'Administrador'
    
    redirect_to root_path, danger: 'No tienes permisos para realizar esta acción.'
  end
end