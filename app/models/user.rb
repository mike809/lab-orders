class User < ApplicationRecord
  MATRICULA_REGEXP = /\d{8}/
  private_constant :MATRICULA_REGEXP

  devise :omniauthable, omniauth_providers: [:azure_oauth2]

  enum role: {
    student: 'student',
    teacher: 'teacher',
    administrator: 'administrator',
    patient: 'patient'
  }

  before_validation :set_generated_username, unless: ->(user) { user.username.present? }
  before_validation :set_generated_email, unless: ->(user) { user.email.present? }

  validates :username, :email, :full_name, presence: :true

  alias :admin? :administrator?
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.full_name = auth.info.name.downcase.titleize
      user.username = username(user.email)
      user.role = default_role(user.username)
    end
  end

  def self.username(email)
    email.split('@').first
  end

  def self.default_role(username)
    username =~ MATRICULA_REGEXP ? :student : :teacher
  end

  private_class_method :default_role

  private

  def set_generated_username
    unless self.username.present?
      self.username = UniqueUsernameGenerator.for_user(self)
    end
  end

  def set_generated_email
    self.email = "#{self.username}@estomatologia.pucmm.edu.do"
  end
end
