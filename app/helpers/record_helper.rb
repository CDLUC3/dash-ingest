module RecordHelper
  def user
    user = @user.external_id
  end
  def campus
    isTest ? campus = "cdl" : campus = Record.id_to_campus(user)
  end
end
