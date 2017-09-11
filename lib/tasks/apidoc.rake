namespace :apidoc do
  desc "Generate documentation"
  task g: :environment do
    app_dir = Rails.root.join('app/')
    apidoc_dir = Rails.root.join('public/apidoc/')
    system("apidoc -i #{app_dir} -o #{apidoc_dir}")
  end
end
