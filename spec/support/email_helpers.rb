module EmailHelpers
  def email_count
    ActionMailer::Base.deliveries.count
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end
end