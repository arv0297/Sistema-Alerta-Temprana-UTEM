
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  has_many :estudiantes
  belongs_to :facultad, optional:true
  belongs_to :rol, optional:true
  belongs_to :carrera, optional:true
  validates :rol_id, presence: true
  validates :estado, :inclusion => {:in=> [true,false]}
  validates :nombre, presence:  { message: 'Ingrese el primer nombre '} , length: {in: 3..40, message:'El nombre debe ser de mínimo largo 3'}, format: {with: /\A[a-zA-Z\s]+\z/,
  message: "Se permiten solo letras en los nombres"}
  validates :apellidopa, presence: { message: 'Ingrese el primer apellido'}, length: {in: 3..20, message:'El apellido debe ser de mínimo largo 3'}, format: {with: /\A[a-zA-Z\s]+\z/,message: "Se permiten solo letras en los apellidos"}
  validates :apellidoma, presence: { message: 'Ingrese el segundo apellido'}, length: {in: 3..20, message:'El apellido debe ser de mínimo largo 3'}, format: {with: /\A[a-zA-Z\s]+\z/, message: "Se permiten solo letras en los apellidos"}
  include RunCl::ActAsRun
  Run.valid? '11.1111.111-1'
  Run.format('11.111.111-1')
  validates :rut , presence: { message: 'Ingrese un rut'}, uniqueness: true
  has_run_cl :rut
 validate :unique_rut
 validates :facultad_id, presence:true
validates :fecha_nacimiento , presence: {message: 'Ingrese la fecha de nacimiento'}
validates :telefono, presence: {message: 'Ingrese Telefono'}, length: {is: 9, message:'Largo debe ser 9'}
validate :fecha_de_nacimiento_debe_ser_en_pasado
validate :edadminima



def fecha_de_nacimiento_debe_ser_en_pasado
  if fecha_nacimiento.present? && fecha_nacimiento >= Date.today
  errors.add(:fecha_nacimiento, "debe ser anterior a la fecha de hoy")
  end
end


def edadminima
   if fecha_nacimiento.present? && fecha_nacimiento >= 18.year.ago
        errors.add(:fecha_nacimiento, "debe ser mayor de 18 años")
   end
end




def active_for_authentication?
  super && self.estado
end

def inactive_message
  "Perdon , su cuenta ha sido desactivada"
end



def unique_rut
  self.errors.add(:name, 'Rut ya existente') if Estudiante.where(rut: self.rut).exists?
end




def fullname
  "#{nombre} #{apellidopa} #{apellidoma}" 

end
  

validates :facultad_id, presence:true
validates :rol_id, presence:true






end
















