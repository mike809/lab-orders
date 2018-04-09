module Admin::UserHelper
  def options_for_user_roles_select
    User.roles.map do |role, _|
      [I18n.t("activerecord.enums.user.user_roles.#{role}"), role]
    end
  end
end
