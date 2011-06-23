namespace :spec do
  task :set_env do
    ENV['FAST_TESTS'] = 'true'
  end

  desc "Run only fast tests"
  task :fast => [ :set_env, :spec ] do
  end
end

