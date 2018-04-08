class UniqueUsernameGenerator
  def self.for_user(user)
    username = user.full_name.downcase.gsub(' ', '.')
    taken_usernames = User
      .where("username LIKE ?", "#{username}%")
      .pluck(:username)

    return username if ! taken_usernames.include?(username)

    count = 2
    while true
      new_username = "#{username}_#{count}"
      return new_username if ! taken_usernames.include?(new_username)
      count += 1
    end
  end
end