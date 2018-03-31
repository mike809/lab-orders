class User < ApplicationRecord
  MATRICULA_REGEXP = /\d{8}/
  private_constant :MATRICULA_REGEXP

  devise :omniauthable, omniauth_providers: [:azure_oauth2]

  enum role: [:student, :teacher, :administrator]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.role = default_role(user)
    end
  end

  def self.default_role(user)
    username = user.email.split('@').first
    username =~ MATRICULA_REGEXP ? :student : :teacher
  end

  private_class_method :default_role
end
