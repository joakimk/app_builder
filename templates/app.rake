namespace :app do
  task :ensure_development_environment => :environment do
    raise "Can't reset db in production!" if Rails.env.production?
  end

  desc "Reset database with seed data"
  task :reset => [ :ensure_development_environment,
                   "db:drop", "db:create", "db:schema:load", "db:seed" ]
end

