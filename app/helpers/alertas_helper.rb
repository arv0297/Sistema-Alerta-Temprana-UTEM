module AlertasHelper
  def priority_badge_class(priority)
    case priority&.downcase
    when 'alta'
      'bg-danger text-light'
    when 'media'
      'bg-warning text-dark'
    when 'baja'
      'bg-info text-dark'
    else
      'bg-secondary text-light'
    end
  end

  def full_student_name(estudiante)
    return 'N/A' unless estudiante
    "#{estudiante.nombreestudiante} #{estudiante.apellidopa} #{estudiante.apellidoma}".strip
  end

  def full_user_name(user)
    return 'N/A' unless user
    "#{user.nombre} #{user.apellidopa} #{user.apellidoma}".strip
  end

  def score_class(score, is_average = false)
    threshold = is_average ? 5 : 3
    score <= threshold ? 'text-danger font-weight-bold' : 'text-normal'
  end

  def evaluation_section_present?(evaluations, category)
    evaluations[category]&.any? { |eval| eval[:score] && eval[:score] > 0 }
  end

  def format_date(date)
    date.strftime("%d-%m-%Y") if date
  end

  def can_edit_alerta?
    # Simple authorization - adjust based on your user roles
    return false unless current_user&.rol&.descripcion == 'Jefe de Carrera'
    true # Temporarily allow all users - customize as needed
  end
end
