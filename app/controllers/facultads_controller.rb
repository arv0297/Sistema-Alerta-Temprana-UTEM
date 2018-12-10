class FacultadsController < ApplicationController
  def index
  @facultades=Facultad.all
  end

  def show
   @facultad= Facultad.find(params[:id])
  end 

  def new

   @facultad= Facultad.new

  end

  def create
    @facultad= Facultad.new(nombrefacultad: params[:facultad][:nombrefacultad])
    @facultad.save
    redirect_to @facultad
  end
end