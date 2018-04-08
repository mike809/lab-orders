class UserNotifierMailer < ApplicationMailer
  default from: 'laboratorio@estomatologia.pucmm.edu.do'
  layout "receipt"

  def send_order_received_email(order)
    @order = order
    mail(to: @order.student.email, subject: 'Orden de protesis recibida.')
  end
end
