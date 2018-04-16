class OrderPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    case user_role
    when :student
      record.student == user
    when :administrator, :teacher
      true
    else
      false
    end
  end

  def update?
    user.admin?
  end

  def permitted_attributes_for_create
    case user_role
    when :student
      %i[teacher_id patient_id balance]
    when :administrator, :teacher
      %i[student_id teacher_id patient_id balance]
    end
  end

  class Scope < Scope
    def resolve
      case user.role.to_sym
      when :administrator
        scope.all
      when :student
        scope.where(student: user)
      when :teacher
        scope.where(teacher: user)
      end
    end
  end

  private

  def user_role
    user.role.to_sym
  end
end