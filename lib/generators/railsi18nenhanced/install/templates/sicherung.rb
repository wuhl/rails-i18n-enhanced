  # if File.exist? "app/views/layouts/_menu.html.erb"
  #   if File.read("app/views/layouts/_menu.html.erb").include?("        <ul class=\"dropdown-menu\">\n        </ul>\n")
  #     gsub_file "app/views/layouts/_menu.html.erb",
  #       "        <ul class=\"dropdown-menu\">\n        </ul>\n",
  #       "        <ul class=\"dropdown-menu\">\n" +
  #       "          <li><a class=\"nav-link\" href=<%= projects_path %>><%= t('helpers.titles.index', model: Project.model_name.human(:count=>2)) %><span class=\"sr-only\">(current)</span></a></li>\n" +
  #       "          <li><a class=\"nav-link\" href=<%= new_project_path %>><%= t('helpers.titles.new', model: Project.model_name.human) %><span class=\"sr-only\">(current)</span></a></li>\n" +
  #       "        </ul>\n"
  #   else
  #     insert_into_file "app/views/layouts/_menu.html.erb", :before =>
  #         "        </ul\>\n" +
  #         "      </li\>\n" +
  #         "    <li class=\"nav-item\"\>\n" +
  #         "      <a class=\"nav-link\" href=<%= page_path('about') %\>\><%= t('menu.about') %\></a\>\n" +
  #         "    </li\>" do
  #       "          <li role=\"separator\" class=\"divider\"\></li\>\n" +
  #       "          <li\><a class=\"nav-link\" href=<%= project_phases_path %\>\><%= t('helpers.titles.index', model: ProjectPhase.model_name.human(:count=>2)) %\><span class=\"sr-only\"\>(current)</span\></a\></li\>\n" +
  #       "          <li\><a class=\"nav-link\" href=<%= new_project_phase_path %\>\><%= t('helpers.titles.new', model: ProjectPhase.model_name.human) %\><span class=\"sr-only\"\>(current)</span\></a\></li\>\n"
  #   end
  #   insert_into_file "app/views/layouts/_menu.html.erb", :before =>
  #       "    <li class=\"nav-item\"\>\n" +
  #       "      <a class=\"nav-link\" href=<%= page_path('about') %\>\><%= t('menu.about') %\></a\>\n" +
  #       "    </li\>" do
  #     "    <li class=\"nav-item active\"\>\n" +
  #     "      <a class=\"nav-link\" href=<%= #{plural_table_name}_path %\>\>" +
  #     "<%= #{class_name}.model_name.human %\><span class=\"sr-only\"\>(current)</span\></a\>\n" +
  #     "    </li\>\n"
  # end
