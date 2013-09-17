module Railsi18nenhanced
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Rails I18n Enhanced"
      argument :language_type, :type => :string, :default => 'de', :banner => '*de or other language'

      def add_locales
      	insert_into_file "config/application.rb", :after => "# config.i18n.default_locale = :de\n" do 
      		"    config.encoding = \"utf-8\"\n" +
    			"    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]\n" +
    			"    config.i18n.available_locales = ['en-GB', :#{language_type}]\n" +
    			"    config.i18n.default_locale = :#{language_type}\n"
				end
      end

      def create_language_directories
        empty_directory "config/locales/en"
        empty_directory "config/locales/#{language_type}"
        normalize "config/locales"
        move "config/locales", "config/locales/en"
        copy "config/locales/en", "config/locales/#{language_type}"
        rename "config/locales/#{language_type}", "#{language_type}"
      end

      def add_language
        copy_file "helper.rb", "app/helpers/helper.rb"
        insert_into_file "app/controllers/application_controller.rb", :after => "  protect_from_forgery with: :exception\n" do 
          "  include Helper\n" +
          "\n" +
          "  before_filter :set_locale\n" +
          "\n" +
          "  layout 'application'\n" +
          "\n" +
          "  private\n" +
          "\n" +
          "    def default_url_options(options={})\n" +
          "      { :language => I18n.locale }\n" +
          "    end\n" +
          "\n" +
          "    def set_locale\n" +
          "      if params[:language] != nil\n" +
          "        I18n.locale = params[:language]\n" +
          "      else\n" +
          "        r = request.env['HTTP_ACCEPT_LANGUAGE']\n" +
          "        if r\n" +
          "          r = r.scan(/^[a-z]{2}/).first\n" +
          "          if ['de'].include? r\n" +
          "            I18n.locale = r\n" +
          "          else\n" +
          "            I18n.locale = 'en'\n" +
          "          end\n" +
          "        else\n" +
          "          I18n.locale = 'en'\n" +
          "        end\n" +
          "      end\n" +
          "      Helper.get_generatedynfunctions\n" +
          "    end\n"
        end
        insert_into_file "app/helpers/application_helper.rb", :after => "module ApplicationHelper\n" do
          "\n" +
          "  def l(d)\n" +
          "    d ? I18n.l(d) : \"\"\n" +
          "  end\n" +
          "\n"
        end
        copy_file "de.values.example.values.yml", "config/locales/#{language_type}/#{language_type}.values.example.values.yml"
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