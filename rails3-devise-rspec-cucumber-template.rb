# Application Generator Template
# Modifies a Rails app to use Devise with RSpec and Cucumber
# Usage: rails new APP_NAME -m https://github.com/fortuity/rails3-application-templates/raw/master/rails3-devise-rspec-cucumber-template.rb -T -J

# Information and a tutorial: 
# https://github.com/fortuity/rails3-devise-rspec-cucumber

# Generated using the rails3_devise_wizard gem:
# https://github.com/fortuity/rails3_devise_wizard/

# Based on application template recipes by:
# Michael Bleigh https://github.com/mbleigh
# Fletcher Nichol https://github.com/fnichol
# Daniel Kehoe https://github.com/fortuity
# Ramon Brooker https://github.com/cognition

# If you are customizing this template, you can use any methods provided by Thor::Actions
# http://rdoc.info/rdoc/wycats/thor/blob/f939a3e8a854616784cac1dcff04ef4f3ee5f7ff/Thor/Actions.html
# and Rails::Generators::Actions
# http://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb

# >---------------------------------------------------------------------------<
#
#            _____       _ _   __          ___                  _ 
#           |  __ \     (_) |  \ \        / (_)                | |
#           | |__) |__ _ _| |___\ \  /\  / / _ ______ _ _ __ __| |
#           |  _  // _` | | / __|\ \/  \/ / | |_  / _` | '__/ _` |
#           | | \ \ (_| | | \__ \ \  /\  /  | |/ / (_| | | | (_| |
#           |_|  \_\__,_|_|_|___/  \/  \/   |_/___\__,_|_|  \__,_|
#
#   This template was generated by rails3_devise_wizard, a custom version of
#   RailsWizard, the application template builder. For more information, see:
#   https://github.com/fortuity/rails3_devise_wizard/
#
# >---------------------------------------------------------------------------<

# >----------------------------[ Initial Setup ]------------------------------<

initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY

@recipes = ["jquery", "haml", "rspec", "cucumber", "action_mailer", "devise", "add_user_name", "home_page", "home_page_users", "seed_database", "users_page", "css_setup", "application_layout", "devise_navigation", "cleanup", "ban_spiders", "git"] 

def recipes; @recipes end
def recipe?(name); @recipes.include?(name) end

def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom(@current_recipe || 'wizard', text) end

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + (@current_recipe || "prompt").rjust(10) + "\033[0m\033[36m" + "  #{question}\033[0m"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

def no_wizard?(question); !yes_wizard?(question) end

def multiple_choice(question, choices)
  say_custom('question', question)
  values = {}
  choices.each_with_index do |choice,i| 
    values[(i + 1).to_s] = choice[1]
    say_custom (i + 1).to_s + ')', choice[0]
  end
  answer = ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

@current_recipe = nil
@configs = {}

@after_blocks = []
def after_bundler(&block); @after_blocks << [@current_recipe, block]; end
@after_everything_blocks = []
def after_everything(&block); @after_everything_blocks << [@current_recipe, block]; end
@before_configs = {}
def before_config(&block); @before_configs[@current_recipe] = block; end


say_wizard "Checking configuration. Please confirm your preferences."

# >--------------------------------[ jQuery ]---------------------------------<

@current_recipe = "jquery"
@before_configs["jquery"].call if @before_configs["jquery"]
say_recipe 'jQuery'

config = {}
config['jquery'] = yes_wizard?("Would you like to use jQuery instead of Prototype?") if true && true unless config.key?('jquery')
config['ui'] = yes_wizard?("Would you like to use jQuery UI?") if true && true unless config.key?('ui')
@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/jquery.rb

if config['jquery']
  say_wizard "REMINDER: When creating a Rails app using jQuery..."
  say_wizard "you should add the '-J' flag to 'rails new'"
  after_bundler do
    say_wizard "jQuery recipe running 'after bundler'"
    # remove the Prototype adapter file
    remove_file 'public/javascripts/rails.js'
    # remove the Prototype files (if they exist)
    remove_file 'public/javascripts/controls.js'
    remove_file 'public/javascripts/dragdrop.js'
    remove_file 'public/javascripts/effects.js'
    remove_file 'public/javascripts/prototype.js'
    # add jQuery files
    inside "public/javascripts" do
      get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "rails.js"
      get "https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js", "jquery.js"
      if config['ui']
        get "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/jquery-ui.min.js", "jqueryui.js"
      end
    end
    # adjust the Javascript defaults
    if config['ui']
      inject_into_file 'config/application.rb', "config.action_view.javascript_expansions[:defaults] = %w(jquery jqueryui rails)\n", :after => "config.action_view.javascript_expansions[:defaults] = %w()\n", :verbose => false
    else
      inject_into_file 'config/application.rb', "config.action_view.javascript_expansions[:defaults] = %w(jquery rails)\n", :after => "config.action_view.javascript_expansions[:defaults] = %w()\n", :verbose => false
    end  
    gsub_file "config/application.rb", /config.action_view.javascript_expansions\[:defaults\] = \%w\(\)\n/, ""
  end
else
  recipes.delete('jquery')
end


# >---------------------------------[ HAML ]----------------------------------<

@current_recipe = "haml"
@before_configs["haml"].call if @before_configs["haml"]
say_recipe 'HAML'

config = {}
config['haml'] = yes_wizard?("Would you like to use Haml instead of ERB?") if true && true unless config.key?('haml')
@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/haml.rb

if config['haml']
  gem 'haml', '>= 3.0.25'
  gem 'haml-rails', '>= 0.3.4', :group => :development
else
  recipes.delete('haml')
end


# >---------------------------------[ RSpec ]---------------------------------<

@current_recipe = "rspec"
@before_configs["rspec"].call if @before_configs["rspec"]
say_recipe 'RSpec'

config = {}
config['rspec'] = yes_wizard?("Would you like to use RSpec instead of TestUnit?") if true && true unless config.key?('rspec')
config['factory_girl'] = yes_wizard?("Would you like to use factory_girl for test fixtures with RSpec?") if true && true unless config.key?('factory_girl')
@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/rspec.rb

if config['rspec']
  say_wizard "REMINDER: When creating a Rails app using RSpec..."
  say_wizard "you should add the '-T' flag to 'rails new'"
  gem 'rspec-rails', '>= 2.5.0', :group => [:development, :test]
  if recipes.include? 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.6.7', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', ">= 1.4.1", :group => :test
  end
  if config['factory_girl']
    # use the factory_girl gem for test fixtures
    gem 'factory_girl_rails', ">= 1.1.beta1", :group => :test
  end
else
  recipes.delete('rspec')
end

# note: there is no need to specify the RSpec generator in the config/application.rb file

if config['rspec']
  after_bundler do
    say_wizard "RSpec recipe running 'after bundler'"
    generate 'rspec:install'
    
    say_wizard "Removing test folder (not needed for RSpec)"
    run 'rm -rf test/'

    if recipes.include? 'mongoid'
      
      # remove ActiveRecord artifacts
      gsub_file 'spec/spec_helper.rb', /config.fixture_path/, '# config.fixture_path'
      gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures/, '# config.use_transactional_fixtures'
      
      # reset your application database to a pristine state during testing
      inject_into_file 'spec/spec_helper.rb', :before => "\nend" do
      <<-RUBY
  \n
  # Clean up the database
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
RUBY
      end

      # remove either possible occurrence of "require rails/test_unit/railtie"
      gsub_file 'config/application.rb', /require 'rails\/test_unit\/railtie'/, '# require "rails/test_unit/railtie"'
      gsub_file 'config/application.rb', /require "rails\/test_unit\/railtie"/, '# require "rails/test_unit/railtie"'

      # configure RSpec to use matchers from the mongoid-rspec gem
      create_file 'spec/support/mongoid.rb' do 
      <<-RUBY
RSpec.configure do |config|
  config.include Mongoid::Matchers
end
RUBY
      end
    end

    if recipes.include? 'devise'
      # add Devise test helpers
      create_file 'spec/support/devise.rb' do 
      <<-RUBY
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
RUBY
      end
    end

  end
end


# >-------------------------------[ Cucumber ]--------------------------------<

@current_recipe = "cucumber"
@before_configs["cucumber"].call if @before_configs["cucumber"]
say_recipe 'Cucumber'

config = {}
config['cucumber'] = yes_wizard?("Would you like to use Cucumber for your BDD?") if true && true unless config.key?('cucumber')
@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/cucumber.rb

if config['cucumber']
  gem 'cucumber-rails', ">= 0.4.1", :group => :test
  gem 'capybara', ">= 0.4.1.2", :group => :test
  gem 'database_cleaner', '>= 0.6.7', :group => :test
  gem 'launchy', ">= 0.4.0", :group => :test
else
  recipes.delete('cucumber')
end

if config['cucumber']
  after_bundler do
    say_wizard "Cucumber recipe running 'after bundler'"
    generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' if recipes.include?('mongoid')}"
    if recipes.include? 'mongoid'
      gsub_file 'features/support/env.rb', /transaction/, "truncation"
      inject_into_file 'features/support/env.rb', :after => 'begin' do
        "\n  DatabaseCleaner.orm = 'mongoid'"
      end
    end
  end
end

if config['cucumber']
  if recipes.include? 'devise'
    after_bundler do
      say_wizard "Copying Cucumber scenarios from the rails3-mongoid-devise examples"
      # copy all the Cucumber scenario files from the rails3-mongoid-devise example app
      inside 'features/users' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/sign_in.feature', 'sign_in.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/sign_out.feature', 'sign_out.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/sign_up.feature', 'sign_up.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/user_edit.feature', 'user_edit.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/user_show.feature', 'user_show.feature'
      end
      inside 'features/step_definitions' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/step_definitions/user_steps.rb', 'user_steps.rb'
      end
      remove_file 'features/support/paths.rb'
      inside 'features/support' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/support/paths.rb', 'paths.rb'
      end
    end
  end
end


# >-----------------------------[ ActionMailer ]------------------------------<

@current_recipe = "action_mailer"
@before_configs["action_mailer"].call if @before_configs["action_mailer"]
say_recipe 'ActionMailer'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/action_mailer.rb

after_bundler do
  say_wizard "ActionMailer recipe running 'after bundler'"
  # modifying environment configuration files for ActionMailer
  gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '# ActionMailer Config'
  gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  <<-RUBY
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
RUBY
  end
  gsub_file 'config/environments/production.rb', /config.active_support.deprecation = :notify/ do
  <<-RUBY
config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'yourhost.com' }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"
RUBY
  end
  
end


# >--------------------------------[ Devise ]---------------------------------<

@current_recipe = "devise"
@before_configs["devise"].call if @before_configs["devise"]
say_recipe 'Devise'

config = {}
config['devise'] = yes_wizard?("Would you like to use Devise for authentication?") if true && true unless config.key?('devise')
@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/devise.rb

if config['devise']
  gem "devise", ">= 1.3.3"
else
  recipes.delete('devise')
end


if config['devise']
  after_bundler do
    
    say_wizard "Devise recipe running 'after bundler'"
    
    # Run the Devise generator
    generate 'devise:install'

    if recipes.include? 'mongo_mapper'
      gem 'mm-devise'
      gsub_file 'config/initializers/devise.rb', 'devise/orm/', 'devise/orm/mongo_mapper_active_model'
      generate 'mongo_mapper:devise User'
    elsif recipes.include? 'mongoid'
      # Nothing to do (Devise changes its initializer automatically when Mongoid is detected)
      # gsub_file 'config/initializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
    end
  
    # Prevent logging of password_confirmation
    gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'

    # Generate models and routes for a User
    generate 'devise user'
    
  end

  after_everything do

    say_wizard "Devise recipe running 'after everything'"

    if recipes.include? 'rspec'
      say_wizard "Copying RSpec files from the rails3-mongoid-devise examples"
      # copy all the RSpec specs files from the rails3-mongoid-devise example app
      inside 'spec' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/spec/factories.rb', 'factories.rb'
      end
      remove_file 'spec/controllers/home_controller_spec.rb'
      remove_file 'spec/controllers/users_controller_spec.rb'
      inside 'spec/controllers' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/spec/controllers/home_controller_spec.rb', 'home_controller_spec.rb'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/spec/controllers/users_controller_spec.rb', 'users_controller_spec.rb'
      end
      remove_file 'spec/models/user_spec.rb'
      inside 'spec/models' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/spec/models/user_spec.rb', 'user_spec.rb'
      end
      remove_file 'spec/views/home/index.html.erb_spec.rb'
      remove_file 'spec/views/home/index.html.haml_spec.rb'
      remove_file 'spec/views/users/show.html.erb_spec.rb'
      remove_file 'spec/views/users/show.html.haml_spec.rb'
      remove_file 'spec/helpers/home_helper_spec.rb'
      remove_file 'spec/helpers/users_helper_spec.rb'
    end

  end
end


# >------------------------------[ AddUserName ]------------------------------<

@current_recipe = "add_user_name"
@before_configs["add_user_name"].call if @before_configs["add_user_name"]
say_recipe 'AddUserName'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/add_user_name.rb

after_bundler do
  
  say_wizard "AddUserName recipe running 'after bundler'"
  
  # Add a 'name' attribute to the User model
  if recipes.include? 'mongoid'
    gsub_file 'app/models/user.rb', /end/ do
  <<-RUBY
  field :name
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
end
RUBY
    end
  else
    # for ActiveRecord
    # Devise created a Users database, we'll modify it
    generate 'migration AddNameToUsers name:string'
    # Devise created a Users model, we'll modify it
    gsub_file 'app/models/user.rb', /attr_accessible :email/, 'attr_accessible :name, :email'
    inject_into_file 'app/models/user.rb', :before => 'validates_uniqueness_of' do
      "validates_presence_of :name\n"
    end
    gsub_file 'app/models/user.rb', /validates_uniqueness_of :email/, 'validates_uniqueness_of :name, :email'
  end

  if recipes.include? 'devise'
    unless recipes.include? 'haml'
      
      # Generate Devise views (unless you are using Haml)
      run 'rails generate devise:views'
      
      # Modify Devise views to add 'name'
      inject_into_file "app/views/devise/registrations/edit.html.erb", :after => "<%= devise_error_messages! %>\n" do
      <<-ERB
<p><%= f.label :name %><br />
<%= f.text_field :name %></p>
ERB
      end

      inject_into_file "app/views/devise/registrations/new.html.erb", :after => "<%= devise_error_messages! %>\n" do
      <<-ERB
<p><%= f.label :name %><br />
<%= f.text_field :name %></p>
ERB
      end

    else

      # copy Haml versions of modified Devise views
      inside 'app/views/devise/registrations' do
        get 'https://github.com/fortuity/rails3-application-templates/raw/master/files/rails3-mongoid-devise/app/views/devise/registrations/edit.html.haml', 'edit.html.haml'
        get 'https://github.com/fortuity/rails3-application-templates/raw/master/files/rails3-mongoid-devise/app/views/devise/registrations/new.html.haml', 'new.html.haml'
      end

    end

  end

end


# >-------------------------------[ HomePage ]--------------------------------<

@current_recipe = "home_page"
@before_configs["home_page"].call if @before_configs["home_page"]
say_recipe 'HomePage'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/home_page.rb

after_bundler do
  
  say_wizard "HomePage recipe running 'after bundler'"
  
  # remove the default home page
  remove_file 'public/index.html'
  
  # create a home controller and view
  generate(:controller, "home index")

  # set up a simple home page (with placeholder content)
  if recipes.include? 'haml'
    remove_file 'app/views/home/index.html.haml'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/views/home/index.html.haml' do 
    <<-'HAML'
%h3 Home
HAML
    end
  else
    remove_file 'app/views/home/index.html.erb'
    create_file 'app/views/home/index.html.erb' do 
    <<-ERB
<h3>Home</h3>
ERB
    end
  end

  # set routes
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'

end


# >-----------------------------[ HomePageUsers ]-----------------------------<

@current_recipe = "home_page_users"
@before_configs["home_page_users"].call if @before_configs["home_page_users"]
say_recipe 'HomePageUsers'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/home_page_users.rb

after_bundler do

  say_wizard "HomePageUsers recipe running 'after bundler'"

  # Modify the home controller
  gsub_file 'app/controllers/home_controller.rb', /def index/ do
  <<-RUBY
def index
  @users = User.all
RUBY
  end

  # Replace the home page
  if recipes.include? 'haml'
    remove_file 'app/views/home/index.html.haml'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/views/home/index.html.haml' do 
    <<-'HAML'
%h3 Home
- @users.each do |user|
  %p User: #{user.name}
HAML
    end
  else
    append_file 'app/views/home/index.html.erb' do <<-ERB
<h3>Home</h3>
<% @users.each do |user| %>
  <p>User: <%= user.name %></p>
<% end %>
ERB
    end
  end

end


# >-----------------------------[ SeedDatabase ]------------------------------<

@current_recipe = "seed_database"
@before_configs["seed_database"].call if @before_configs["seed_database"]
say_recipe 'SeedDatabase'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/seed_database.rb


after_bundler do

  say_wizard "SeedDatabase recipe running 'after bundler'"

  unless recipes.include? 'mongoid'
    run 'rake db:migrate'
  end

  if recipes.include? 'mongoid'
    # create a default user
    append_file 'db/seeds.rb' do <<-FILE
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
FILE
    end
  end

  # create a default user
  append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
FILE
  end
      
  run 'rake db:seed'

end


# >-------------------------------[ UsersPage ]-------------------------------<

@current_recipe = "users_page"
@before_configs["users_page"].call if @before_configs["users_page"]
say_recipe 'UsersPage'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/users_page.rb

after_bundler do

  say_wizard "UsersPage recipe running 'after bundler'"

    #----------------------------------------------------------------------------
    # Create a users controller
    #----------------------------------------------------------------------------
    generate(:controller, "users show")
    gsub_file 'app/controllers/users_controller.rb', /def show/ do
    <<-RUBY
before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
RUBY
    end

    #----------------------------------------------------------------------------
    # Modify the routes
    #----------------------------------------------------------------------------
    # @devise_for :users@ route must be placed above @resources :users, :only => :show@.
    gsub_file 'config/routes.rb', /get \"users\/show\"/, '#get \"users\/show\"'
    gsub_file 'config/routes.rb', /devise_for :users/ do
    <<-RUBY
devise_for :users
  resources :users, :only => :show
RUBY
    end

    #----------------------------------------------------------------------------
    # Create a users show page
    #----------------------------------------------------------------------------
    if recipes.include? 'haml'
      remove_file 'app/views/users/show.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/users/show.html.haml' do <<-'HAML'
%p
  User: #{@user.name}
HAML
      end
    else
      append_file 'app/views/users/show.html.erb' do <<-ERB
<p>User: <%= @user.name %></p>
ERB
      end
    end

    #----------------------------------------------------------------------------
    # Create a home page containing links to user show pages
    # (clobbers code from the home_page_users recipe)
    #----------------------------------------------------------------------------
    # set up the controller
    remove_file 'app/controllers/home_controller.rb'
    create_file 'app/controllers/home_controller.rb' do
    <<-RUBY
class HomeController < ApplicationController
  def index
    @users = User.all
  end
end
RUBY
    end

    # modify the home page
    if recipes.include? 'haml'
      remove_file 'app/views/home/index.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/home/index.html.haml' do
      <<-'HAML'
%h3 Home
- @users.each do |user|
  %p User: #{link_to user.name, user}
HAML
      end
    else
      remove_file 'app/views/home/index.html.erb'
      create_file 'app/views/home/index.html.erb' do <<-ERB
<h3>Home</h3>
<% @users.each do |user| %>
  <p>User: <%=link_to user.name, user %></p>
<% end %>
ERB
      end
    end

end


# >-------------------------------[ CssSetup ]--------------------------------<

@current_recipe = "css_setup"
@before_configs["css_setup"].call if @before_configs["css_setup"]
say_recipe 'CssSetup'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/css_setup.rb

after_bundler do

  say_wizard "CssSetup recipe running 'after bundler'"

  # Add a stylesheet with styles for a horizontal menu and flash messages
  create_file 'public/stylesheets/application.css' do <<-CSS
ul.hmenu {
  list-style: none;	
  margin: 0 0 2em;
  padding: 0;
}
ul.hmenu li {
  display: inline;  
}
#flash_notice, #flash_alert {
  padding: 5px 8px;
  margin: 10px 0;
}
#flash_notice {
  background-color: #CFC;
  border: solid 1px #6C6;
}
#flash_alert {
  background-color: #FCC;
  border: solid 1px #C66;
}
CSS
  end

end


# >---------------------------[ ApplicationLayout ]---------------------------<

@current_recipe = "application_layout"
@before_configs["application_layout"].call if @before_configs["application_layout"]
say_recipe 'ApplicationLayout'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/application_layout.rb

after_bundler do

  say_wizard "ApplicationLayout recipe running 'after bundler'"

  # Set up the default application layout
  if recipes.include? 'haml'
    remove_file 'app/views/layouts/application.html.erb'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    create_file 'app/views/layouts/application.html.haml' do <<-HAML
!!!
%html
  %head
    %title #{app_name}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    - flash.each do |name, msg|
      = content_tag :div, msg, :id => "flash_\#{name}" if msg.is_a?(String)
    = yield
HAML
    end
  else
    inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
  <<-ERB
  <%- flash.each do |name, msg| -%>
    <%= content_tag :div, msg, :id => "flash_\#{name}" if msg.is_a?(String) %>
  <%- end -%>
ERB
    end
  end

end


# >---------------------------[ DeviseNavigation ]----------------------------<

@current_recipe = "devise_navigation"
@before_configs["devise_navigation"].call if @before_configs["devise_navigation"]
say_recipe 'DeviseNavigation'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/devise_navigation.rb

after_bundler do

  say_wizard "DeviseNavigation recipe running 'after bundler'"

    # Create navigation links for Devise
    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file "app/views/devise/menu/_login_items.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    = link_to('Logout', destroy_user_session_path)
- else
  %li
    = link_to('Login', new_user_session_path)
HAML
      end
    else
      create_file "app/views/devise/menu/_login_items.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  <%= link_to('Logout', destroy_user_session_path) %>        
  </li>
<% else %>
  <li>
  <%= link_to('Login', new_user_session_path)  %>  
  </li>
<% end %>
ERB
      end
    end

    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file "app/views/devise/menu/_registration_items.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    = link_to('Edit account', edit_user_registration_path)
- else
  %li
    = link_to('Sign up', new_user_registration_path)
HAML
      end
    else
      create_file "app/views/devise/menu/_registration_items.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  <%= link_to('Edit account', edit_user_registration_path) %>
  </li>
<% else %>
  <li>
  <%= link_to('Sign up', new_user_registration_path)  %>
  </li>
<% end %>
ERB
      end
    end

    # Add navigation links to the default application layout
    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      inject_into_file 'app/views/layouts/application.html.haml', :after => "%body\n" do <<-HAML
  %ul.hmenu
    = render 'devise/menu/registration_items'
    = render 'devise/menu/login_items'
HAML
      end
    else
      inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
  <<-ERB
  <ul class="hmenu">
    <%= render 'devise/menu/registration_items' %>
    <%= render 'devise/menu/login_items' %>
  </ul>
ERB
      end
    end

end


# >--------------------------------[ Cleanup ]--------------------------------<

@current_recipe = "cleanup"
@before_configs["cleanup"].call if @before_configs["cleanup"]
say_recipe 'Cleanup'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/cleanup.rb

after_bundler do

  say_wizard "Cleanup recipe running 'after bundler'"

  # remove unnecessary files
  %w{
    README
    doc/README_FOR_APP
    public/index.html
    public/images/rails.png
  }.each { |file| remove_file file }

  # add placeholder READMEs
  get "https://github.com/fortuity/rails-template-recipes/raw/master/sample_readme.txt", "README"
  get "https://github.com/fortuity/rails-template-recipes/raw/master/sample_readme.textile", "README.textile"
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

  # remove commented lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file "Gemfile", /#.*\n/, "\n"
  gsub_file "Gemfile", /\n+/, "\n"

end


# >------------------------------[ BanSpiders ]-------------------------------<

@current_recipe = "ban_spiders"
@before_configs["ban_spiders"].call if @before_configs["ban_spiders"]
say_recipe 'BanSpiders'

config = {}
config['ban_spiders'] = yes_wizard?("Would you like to set a robots.txt file to ban spiders?") if true && true unless config.key?('ban_spiders')
@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/ban_spiders.rb

if config['ban_spiders']
  say_wizard "BanSpiders recipe running 'after bundler'"
  after_bundler do
    # ban spiders from your site by changing robots.txt
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
else
  recipes.delete('ban_spiders')
end


# >----------------------------------[ Git ]----------------------------------<

@current_recipe = "git"
@before_configs["git"].call if @before_configs["git"]
say_recipe 'Git'


@configs[@current_recipe] = config

# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/git.rb

after_everything do
  say_wizard "Git recipe running 'after everything'"
  # Git should ignore some files
  remove_file '.gitignore'
  get "https://github.com/fortuity/rails3-gitignore/raw/master/gitignore.txt", ".gitignore"
  # Initialize new Git repo
  git :init
  git :add => '.'
  git :commit => "-aqm 'new Rails app generated by rails3_devise_wizard'"
  # Create a git branch
  git :checkout => ' -b working_branch'
  git :add => '.'
  git :commit => "-m 'Initial commit of working_branch'"
end





@current_recipe = nil

# >-----------------------------[ Run Bundler ]-------------------------------<

say_wizard "Running 'bundle install'. This will take a while."
run 'bundle install'
say_wizard "Running 'after bundler' callbacks."
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
say_wizard "Running 'after everything' callbacks."
@after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
say_wizard "Finished running the rails3_devise_wizard app template."
say_wizard "Your new Rails app is ready. Any problems?"
say_wizard "See http://github.com/fortuity/rails3-mongoid-devise/issues"