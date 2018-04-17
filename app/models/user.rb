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

  has_many :student_orders, foreign_key: 'student_id', class_name: 'Order'

  scope :with_orders, lambda {
    joins(:student_orders)
      .select('users.*, sum(balance) as pending_balance')
      .group('users.id')
  }

  scope :without_orders, lambda {
    joins('LEFT OUTER JOIN orders on orders.student_id=users.id')
      .select('users.*, 0 as pending_balance')
      .where(orders: { student_id: nil })
  }

  before_validation :set_generated_username, if: lambda {
    username.nil? && full_name.present?
  }

  before_validation :set_generated_email, unless: ->(user) { user.email.present? }

  validates :full_name, presence: true
  validates :username, :email, presence: true, if: ->(user) { user.full_name.present? }

  alias admin? administrator?
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

  def pending_balance
    defined?(super) ? super : student_orders.with_pending_balance.sum(:balance)
  end

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
