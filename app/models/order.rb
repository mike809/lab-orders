class Order < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :patient, class_name: 'User'
  belongs_to :teacher, class_name: 'User'

  validate :teacher_has_correct_role, :student_has_correct_role, :patient_has_correct_role

  scope :with_pending_balance, -> { where('balance > 0') }

  def barcode
    @barcode ||= Barcoder.new(id).to_html
  end

  def transition!
    UserNotifierMailer.send_order_received_email(self).deliver
  end

  private

  def teacher_has_correct_role
    errors.add(:teacher, 'Profesor debe tener el rol correcto') unless teacher.teacher?
  end

  def student_has_correct_role
    errors.add(:student, 'Estudiante debe tener el rol correcto') unless student.student?
  end

  def patient_has_correct_role
    errors.add(:patient, 'Paciente debe tener el rol correcto') unless patient.patient?
  end
end
