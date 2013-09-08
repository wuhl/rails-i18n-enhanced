# helper.rb:
module Helper

  def get_generatedynfunctions
    if I18n.locale == ''
      I18n.locale = 'de'
    end

    I18n.t(:values).each do |k1, v1|
      v1.each do |k2, v2|
        define_method "#{k1}_#{k2}_values" do
          v2.map { |key, value| [value, key] }.sort { |a, b| a[1] <=> b[1] }
        end

        define_method "get_#{k1}_#{k2}" do |x|
          x ? eval("#{k1}_#{k2}_values")[x][0] : ""
        end
      end
    end
  end

  module_function :get_generatedynfunctions
end