class AlertasController < ApplicationController
  layout "prueba"
  before_action :set_alerta, only: [:show]
  before_action :authorize_alerta_access

  # GET /alertas
  def index
    @alertas = Alerta.includes(informe: [:estudiante, :user])
                     .order(created_at: :desc)
  end

  # GET /alertas/1
  def show
    @informe = @alerta.informe
    @evaluations = organize_evaluations(@informe)
  end

  private

  def set_alerta
    @alerta = Alerta.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to alertas_path, alert: 'Alerta no encontrada'
  end

  def authorize_alerta_access
    # Add authorization logic here based on user role
    # Example: current_user.can_access_alerta?(@alerta)
  end

  def organize_evaluations(informe)
    {
      habits: extract_habits_evaluations(informe),
      vocation: extract_vocation_evaluations(informe),
      health: extract_health_evaluations(informe)
    }
  end

  def extract_habits_evaluations(informe)
    [
      { question: habits_question_for_role(informe, 1), score: informe.nota1 },
      { question: habits_question_for_role(informe, 2), score: informe.nota2 },
      { question: habits_question_for_role(informe, 3), score: informe.nota3 },
      { question: habits_question_for_role(informe, 4), score: informe.nota4 },
      { question: habits_question_for_role(informe, 5), score: informe.nota5 },
      { question: 'Promedio Hábitos de estudio', score: informe.promhabitos, is_average: true }
    ]
  end

  def extract_vocation_evaluations(informe)
    [
      { question: vocation_question_for_role(informe, 6), score: informe.nota6 },
      { question: vocation_question_for_role(informe, 7), score: informe.nota7 },
      { question: vocation_question_for_role(informe, 8), score: informe.nota8 },
      { question: vocation_question_for_role(informe, 9), score: informe.nota9 },
      { question: vocation_question_for_role(informe, 10), score: informe.nota10 },
      { question: 'Promedio Vocación', score: informe.promvocacion, is_average: true }
    ]
  end

  def extract_health_evaluations(informe)
    [
      { question: health_question_for_role(informe, 11), score: informe.nota11 },
      { question: health_question_for_role(informe, 12), score: informe.nota12 },
      { question: health_question_for_role(informe, 13), score: informe.nota13 },
      { question: health_question_for_role(informe, 14), score: informe.nota14 },
      { question: health_question_for_role(informe, 15), score: informe.nota15 },
      { question: 'Promedio Salud Física y Mental', score: informe.promsalud, is_average: true }
    ]
  end

  def habits_question_for_role(informe, question_number)
    role_questions = {
      'Sicologo' => [
        'Si tiene problemas con materias, ¿que tan grave es?',
        '¿Cómo considera que es la comprensión de los contenidos que estudia?',
        '¿En relación al espacio físico de su lugar de estudio, ¿cómo lo califica?',
        '¿Cómo es el tiempo que dedica a estudiar?',
        '¿Cómo estima que son sus calificaciones en función de su estudio y esfuerzo?'
      ],
      'Asistente Social' => [
        'Pensando en las últimas semanas, ¿cómo considera que es el tiempo que destinó para estudiar y preparar sus exámenes?',
        '¿Cómo ha que sido el trabajo colaborativo con sus compañeros al momento de estudiar en los últimos días?',
        '¿Cómo califica la atención- concentración al momento de estudiar?',
        'En los últimos días, ¿estima que los problemas afectivos han perjudicado su rendimiento?',
        'En el estudio de las últimas evaluaciones, ¿cómo consideras que ha trabajado con métodos de estudio?(mapas conceptuales, resumen, etc.)'
      ],
      'Tutor' => [
        'Referente al tiempo que ha dedicado al estudio estos últimos días, ¿cómo considera que han sido los resultados académicos?',
        'En relación a la concentración cuando estudia, ¿qué nivel considera que logra alcanzar?',
        '¿Cómo considera que es su organización para estudiar y realizar trabajos? (horario de repaso, investigación, etc.)',
        '¿Cómo es el espacio que destina para poder estudiar y realizar trabajos?',
        '¿Cómo considera que es su comprensión cuando estudia o realiza trabajos en horarios no adecuados? (día previo a una prueba o entrega de trabajos, en la madrugada, etc.)'
      ]
    }
    
    questions = role_questions[informe.user&.rol&.descripcion] || []
    questions[question_number - 1] || "Pregunta #{question_number}"
  end

  def vocation_question_for_role(informe, question_number)
    role_questions = {
      'Sicologo' => [
        '¿Cómo considera que fue la elección que hizo de la carrera que cursa?',
        'Con respecto a su elección universitaria, ¿cómo la califica hoy?',
        '¿Cómo piensa que son los contenidos de las materias que imparte su carrera?',
        '¿Qué tan drásticos cree que han sido los cambios a lo largo del tiempo en relación a su vocación?',
        '¿Cómo considera su nivel de vocación de elección universitaria antes de ingresar a la educación superior?'
      ],
      'Asistente Social' => [
        'A partir de lo aprendido en el último tiempo, ¿cómo cree que es la relación entre su vocación y preparación?',
        'En los últimos días, ¿cómo se ha sentido con la decisión de estudiar la carrera que cursa?',
        '¿Cómo considera la preparación de las clases de los docentes?',
        '¿Cómo estima que es la relación de sus notas versus su preparación en el último tiempo?',
        'Pensando en las últimas semanas, ¿cómo ha sido el aporte social para el desarrollo vocacional?'
      ],
      'Tutor' => [
        '¿Cómo estima que ha sido su actitud al asistir a clases?',
        'En función a las clases asistidas, ¿cómo cumplen con sus expectativas vocacionales?',
        '¿Cómo se ha sentido en los últimos días respecto a su decisión de cursar esta carrera universitaria?',
        '¿Cómo se siente luego de obtener una calificación que no esperaba?',
        'En el último tiempo, ¿cómo considera que influye su vocación en el futuro laboral?'
      ]
    }
    
    questions = role_questions[informe.user&.rol&.descripcion] || []
    questions[question_number - 6] || "Pregunta #{question_number}"
  end

  def health_question_for_role(informe, question_number)
    role_questions = {
      'Sicologo' => [
        '¿Cómo considera que fue la elección que hizo de la carrera que cursa?',
        'Con respecto a su elección universitaria, ¿cómo la califica hoy?',
        '¿Cómo piensa que son los contenidos de las materias que imparte su carrera?',
        '¿Qué tan drásticos cree que han sido los cambios a lo largo del tiempo en relación a su vocación?',
        '¿Cómo considera su nivel de vocación de elección universitaria antes de ingresar a la educación superior comparada con hoy?'
      ],
      'Asistente Social' => [
        'En la Sala de clases, si tiene problemas de concentracion, que tan frecuentes son?',
        '¿Siente malestar fisico o emocional al estar en la sala de clases con mas personas?',
        '¿Ha dejado la actividad fisica o los estudios, solo por que no se siente bien emocionalmente?',
        '¿Si tiene alteraciones de sueño, que tan frecuentes son?',
        '¿Es capaz de expresar abiertamiente su opinion y compartir con compañeros?'
      ],
      'Tutor' => [
        '¿Cómo cree que se relaciona con sus compañeros al momento de estudiar, aclarar dudas o solicitar contenidos?',
        '¿Cómo considera que se ha alimentado estos últimos días en razón a su estado de ánimo?',
        'En razón de las actividades físicas y/o recreativas, ¿cómo cree que han sido éstas en el último periodo?',
        '¿Cómo sientes que es el aporte que brinda su grupo de compañeros y/o amigos en su salud física y mental?',
        '¿Cuál crees que es el aporte que entrega su estado mental al rendimiento académico?'
      ]
    }
    
    questions = role_questions[informe.user&.rol&.descripcion] || []
    questions[question_number - 11] || "Pregunta #{question_number}"
  end
end