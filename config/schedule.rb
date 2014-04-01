every :sunday, :at => '4am' do # Use any day of the week or :weekend, :weekday
  runner "Upload.purge_old_files"
end