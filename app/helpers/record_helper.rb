module RecordHelper
  def user
    user = @user.external_id
  end
  def campus
    campus = @records.first.id_to_campus(user)
  end
end
