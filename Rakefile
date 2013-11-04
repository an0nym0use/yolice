require './lib/yolice'

namespace :licenses do

  desc "List the licenses of your gems" 
  task :list do
    puts Yolice::YoLicense.new.raw_licenses
  end

  desc "Explain what licensing situation"
  task :explain do
    Yolice::YoLicense.new.match_licenses.col_features.print_explanations
  end

end