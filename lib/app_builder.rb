require 'rubygems'
require 'thor'

class AppBuilder < Thor
  include Thor::Actions

  def self.source_root
    File.dirname(__FILE__) + "/../templates"
  end

  desc "new app_name", "Create new app"
  def new(name)
    system "rails new #{name} -T -d postgresql --skip-bundle"
    remove_file "#{name}/Gemfile"
    copy_file "Gemfile", "#{name}/Gemfile"
    copy_file "Guardfile", "#{name}/Guardfile"
    remove_file "#{name}/config/environments/test.rb"
    copy_file "test.rb", "#{name}/config/environments/test.rb" # disable caching to make spork work better
    copy_file "test.rake", "#{name}/lib/tasks/test.rake"       # "rake" to run rspec
    copy_file "app.rake", "#{name}/lib/tasks/app.rake" 
    copy_file "spec.rake", "#{name}/lib/tasks/spec.rake" 
    remove_file "#{name}/config/database.yml"

    @name = name
    template "rvmrc.erb", "#{name}/.rvmrc"
    template "database.yml.erb", "#{name}/config/database.yml"

    system <<STR
    source "$HOME/.rvm/scripts/rvm" &&
    cd #{name} &&
    rvm @#{name} &&
    bundle install --binstubs .bundle/bin &&
    rails g rspec:install
STR
  
    remove_file "#{name}/spec/spec_helper.rb"
    copy_file "spec_helper.rb", "#{name}/spec/spec_helper.rb"

  end 

  desc 'scaffold app', 'Run a scaffold and prepare databases'
  def scaffold(name)
    system <<STR
    source "$HOME/.rvm/scripts/rvm" &&
    cd #{name} &&
    rvm @#{name}
    rails g scaffold post title:string body:text published:boolean
    rake db:drop:all 2> /dev/null
    rake db:create:all
    rake db:migrate
    rake db:test:prepare
STR
  end
end
