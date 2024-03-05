[
  "lib/rails_runner.rb",
  "lib/ircs"
].each do |ignore|
  Rails.autoloaders.main.ignore("#{Rails.root}/#{ignore}")
end
