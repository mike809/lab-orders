# Preview all emails at http://localhost:3000/rails/mailers/user_notifier
class UserNotifierPreview < ActionMailer::Preview
  def send_order_received_email
    @order = OpenStruct.new(
      id: 1,
      patient: OpenStruct.new(full_name: 'Paciente Zero'),
      student: OpenStruct.new(email: 'estudiante@ce.pucmm.edu.do')
    )

    UserNotifierMailer.send_order_received_email(@order)
  end
end
