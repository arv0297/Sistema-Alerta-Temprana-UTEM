class Estudiante < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :carrera
  has_many :informes
  
  validates :nombreestudiante, presence:  { message: 'Ingrese el primer nombre '}, length: {in: 3..40, message:'El nombre debe ser de mínimo largo 3'}, format: {with: /\A[a-zA-Z\s]+\z/,
  message: "Se permiten solo letras en los nombres"}
  validates :direccion, presence: {message: 'Ingrese Dirección'},length: {in: 8..40, message:'El nombre debe ser de mínimo largo 20'}
  validates :comuna, presence: {message: 'Ingrese Comuna'}
  validates :apellidopa, presence: { message: 'Ingrese el primer apellido'}, length: {in: 3..20, message:'El apellido debe ser de mínimo largo 3'}, format: {with: /\A[a-zA-Z\s]+\z/,
  message: "Se permiten solo letras en los apellidos"}
  validates :apellidoma, presence: { message: 'Ingrese el segundo apellido'}, length: {in: 3..20, message:'El apellido debe ser de mínimo largo 3'}, format: {with: /\A[a-zA-Z\s]+\z/,
  message: "Se permiten solo letras en los apellidos"}
  include RunCl::ActAsRun
  Run.valid? '11.1111.111-1'
  Run.format('11.111.111-1')
  validates :rut , presence: { message: 'Ingrese un rut'}, uniqueness: true
  has_run_cl :rut
 validate :unique_rut
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
   if fecha_nacimiento.present? && fecha_nacimiento >= 17.year.ago
        errors.add(:fecha_nacimiento, "debe ser mayor de 17 años")
   end
end
def unique_rut
  self.errors.add(:name, 'Rut ya existente') if User.where(rut: self.rut).exists?
end

def fullname
  "#{nombreestudiante} #{apellidopa} #{apellidoma}" 

end
end



















