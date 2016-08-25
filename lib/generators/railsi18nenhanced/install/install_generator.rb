module Railsi18nenhanced
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Rails I18n Enhanced"
      argument :language_type, :type => :string, :default => 'de', :banner => '*de or other language'
      class_option :template_engine, desc: 'Template engine to be invoked (erb, haml or slim).'

      def add_locales
        insert_into_file "config/application.rb", :after => "class Application < Rails::Application\n" do
          "    config.encoding = \'utf-8\'\n" +
          "    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]\n" +
          "    config.i18n.available_locales = ['en-GB', :#{language_type}]\n" +
          "    config.i18n.default_locale = :#{language_type}\n"
        end
      	# insert_into_file "config/application.rb", :after => "# config.i18n.default_locale = :de\n" do
      	# 	"    config.encoding = \"utf-8\"\n" +
    			# "    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]\n" +
    			# "    config.i18n.available_locales = ['en-GB', :#{language_type}]\n" +
    			# "    config.i18n.default_locale = :#{language_type}\n"
       #  end
      end

      def create_language_directories
        empty_directory "config/locales/en"
        empty_directory "config/locales/#{language_type}"
        normalize "config/locales"
        move "config/locales", "config/locales/en"
        rename "config/locales/#{language_type}", "#{language_type}"
      end

      def add_language
        insert_into_file "app/controllers/application_controller.rb", :after => "  protect_from_forgery with: :exception\n" do
          "  before_action :set_locale\n" +
          "\n" +
          "  layout 'application'\n" +
          "\n" +
          "  private\n" +
          "\n" +
          "#    def default_url_options(options={})\n" +
          "#      { :language => I18n.locale }\n" +
          "#    end\n" +
          "\n" +
          "    def set_locale\n" +
          "      logger.debug \"* Accept-Language: \#{request.env['HTTP_ACCEPT_LANGUAGE']}\"\n" +
          "      I18n.locale = extract_locale_from_accept_language_header\n" +
          "      logger.debug \"* Locale set to '\#{I18n.locale}'\"\n" +
          "    end\n" +
          "\n" +
          "    def extract_locale_from_accept_language_header\n" +
          "      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first\n" +
          "    end\n" +
          "\n"
        end
        insert_into_file "app/helpers/application_helper.rb", :after => "module ApplicationHelper\n" do
          "\n" +
          "  def l(d)\n" +
          "    d ? I18n.l(d) : \"\"\n" +
          "  end\n" +
          "\n"
        end
        copy_file "#{language_type}.yml", "config/locales/#{language_type}/#{language_type}.yml"
        copy_file "#{language_type}.values.example.values.yml", "config/locales/#{language_type}/#{language_type}.values.example.values.yml"
        copy_file "#{language_type}.rails-i18n.yml", "config/locales/#{language_type}/#{language_type}.rails-i18n.yml"
      end

      def copy_scaffold_template
        engine = options[:template_engine]
        copy_file "#{engine}/_form.html.#{engine}", "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
        copy_file "#{engine}/edit.html.#{engine}", "lib/templates/#{engine}/scaffold/edit.html.#{engine}"
        copy_file "#{engine}/index.html.#{engine}", "lib/templates/#{engine}/scaffold/index.html.#{engine}"
        copy_file "#{engine}/new.html.#{engine}", "lib/templates/#{engine}/scaffold/new.html.#{engine}"
        copy_file "#{engine}/show.html.#{engine}", "lib/templates/#{engine}/scaffold/show.html.#{engine}"
      end

      def copy_scaffold_controller
        copy_file "scaffold_controller/controller.rb", "lib/templates/rails/scaffold_controller/controller.rb"
      end

      def accelerate_rails
        gsub_file "config/environments/development.rb", "config.assets.debug = false", "config.assets.debug = true"
      end

      def install_high_voltage
        if File.read("Gemfile").include?("gem 'high_voltage'")
          copy_file "high_voltage.rb", "config/initializers/high_voltage.rb"
        end
      end

      def install_better_errors
        if File.read("Gemfile").include?("gem 'better_errors'")
          copy_file "better_errors.rb", "config/initializers/better_errors.rb"
        end
      end

      def install_other_gems
        if File.read("Gemfile").include?("gem 'cocoon'")
          insert_into_file "app/assets/javascripts/application.js", :before => "//= require_tree .\n" do
            "//= require cocoon\n"
          end
          puts "      Cocoon installed"
        end
      end

    private

      def normalize(source_dir)
        Dir["#{source_dir}/*"].each do |source|
          if FileTest.file?(source)
            sourcename = File.basename(source)
            if sourcename.include?('.en.')
              newname = "en." + sourcename.gsub('.en.','.')
              # puts "      Normalizing #{sourcename} to #{newname}"
              File.rename(source,File.join(File.dirname(source),newname))
            end
          end
        end
      end

      def move(source_dir,dest_dir)
        Dir["#{source_dir}/*"].each do |source|
          if FileTest.file?(source)
            destination = "#{dest_dir}/#{File.basename(source)}"
            if File.exist?(destination)
              puts "      Skipping #{destination} because it already exists"
            else
              puts "      Generating #{destination}"
              FileUtils.move(source, destination)
            end
          end
        end
      end

      def copy(source_dir,dest_dir)
        Dir["#{source_dir}/*"].each do |source|
          if FileTest.file?(source)
            destination = "#{dest_dir}/#{File.basename(source)}"
            if File.exist?(destination)
              puts "      Skipping #{destination} because it already exists"
            else
              puts "      Generating #{destination}"
              FileUtils.cp(source, destination)
            end
          end
        end
      end

      def rename(source_dir, language)
        Dir["#{source_dir}/*"].each do |source|
          if FileTest.file?(source)
            sourcename = File.basename(source)
            if sourcename.start_with?('en.')
              newname = language + sourcename[2..-1]
              puts "      Renaming #{sourcename} to #{newname}"
              File.rename(source,File.join(File.dirname(source),newname))
            end
          end
        end
      end

    end
  end
end
