Gem::Specification.new do |s|
  s.name = %q{rails}
  s.version = "1.2.3"
  s.date = %q{2007-03-13}
  s.summary = %q{Web-application framework with template engine, control-flow layer, and ORM.}
  s.email = %q{david@loudthinking.com}
  s.homepage = %q{http://www.rubyonrails.org}
  s.rubyforge_project = %q{rails}
  s.description = %q{Rails is a framework for building web-application using CGI, FCGI, mod_ruby, or WEBrick on top of either MySQL, PostgreSQL, SQLite, DB2, SQL Server, or Oracle with eRuby- or Builder-based templates.}
  s.default_executable = %q{rails}
  s.authors = ["David Heinemeier Hansson"]
  s.files = ["bin", "builtin", "CHANGELOG", "configs", "dispatches", "doc", "environments", "fresh_rakefile", "helpers", "html", "lib", "MIT-LICENSE", "Rakefile", "README", "bin/about", "bin/breakpointer", "bin/console", "bin/destroy", "bin/generate", "bin/performance", "bin/plugin", "bin/process", "bin/rails", "bin/runner", "bin/server", "bin/performance/benchmarker", "bin/performance/profiler", "bin/process/inspector", "bin/process/reaper", "bin/process/spawner", "builtin/rails_info", "builtin/rails_info/rails", "builtin/rails_info/rails_info_controller.rb", "builtin/rails_info/rails/info.rb", "builtin/rails_info/rails/info_controller.rb", "builtin/rails_info/rails/info_helper.rb", "configs/apache.conf", "configs/databases", "configs/empty.log", "configs/lighttpd.conf", "configs/routes.rb", "configs/databases/frontbase.yml", "configs/databases/mysql.yml", "configs/databases/oracle.yml", "configs/databases/postgresql.yml", "configs/databases/sqlite2.yml", "configs/databases/sqlite3.yml", "doc/README_FOR_APP", "dispatches/dispatch.fcgi", "dispatches/dispatch.rb", "dispatches/gateway.cgi", "environments/boot.rb", "environments/development.rb", "environments/environment.rb", "environments/production.rb", "environments/test.rb", "helpers/application.rb", "helpers/application_helper.rb", "helpers/test_helper.rb", "html/404.html", "html/500.html", "html/favicon.ico", "html/images", "html/index.html", "html/javascripts", "html/robots.txt", "html/images/rails.png", "html/javascripts/application.js", "html/javascripts/controls.js", "html/javascripts/dragdrop.js", "html/javascripts/effects.js", "html/javascripts/prototype.js", "lib/binding_of_caller.rb", "lib/breakpoint.rb", "lib/breakpoint_client.rb", "lib/code_statistics.rb", "lib/commands", "lib/commands.rb", "lib/console_app.rb", "lib/console_sandbox.rb", "lib/console_with_helpers.rb", "lib/dispatcher.rb", "lib/fcgi_handler.rb", "lib/initializer.rb", "lib/rails", "lib/rails_generator", "lib/rails_generator.rb", "lib/railties_path.rb", "lib/ruby_version_check.rb", "lib/rubyprof_ext.rb", "lib/tasks", "lib/test_help.rb", "lib/webrick_server.rb", "lib/commands/about.rb", "lib/commands/breakpointer.rb", "lib/commands/console.rb", "lib/commands/destroy.rb", "lib/commands/generate.rb", "lib/commands/ncgi", "lib/commands/performance", "lib/commands/plugin.rb", "lib/commands/process", "lib/commands/runner.rb", "lib/commands/server.rb", "lib/commands/servers", "lib/commands/update.rb", "lib/commands/ncgi/listener", "lib/commands/ncgi/tracker", "lib/commands/performance/benchmarker.rb", "lib/commands/performance/profiler.rb", "lib/commands/process/inspector.rb", "lib/commands/process/reaper.rb", "lib/commands/process/spawner.rb", "lib/commands/process/spinner.rb", "lib/commands/servers/base.rb", "lib/commands/servers/lighttpd.rb", "lib/commands/servers/mongrel.rb", "lib/commands/servers/webrick.rb", "lib/rails/version.rb", "lib/rails_generator/base.rb", "lib/rails_generator/commands.rb", "lib/rails_generator/generated_attribute.rb", "lib/rails_generator/generators", "lib/rails_generator/lookup.rb", "lib/rails_generator/manifest.rb", "lib/rails_generator/options.rb", "lib/rails_generator/scripts", "lib/rails_generator/scripts.rb", "lib/rails_generator/simple_logger.rb", "lib/rails_generator/spec.rb", "lib/rails_generator/generators/applications", "lib/rails_generator/generators/components", "lib/rails_generator/generators/applications/app", "lib/rails_generator/generators/applications/app/app_generator.rb", "lib/rails_generator/generators/applications/app/USAGE", "lib/rails_generator/generators/components/controller", "lib/rails_generator/generators/components/integration_test", "lib/rails_generator/generators/components/mailer", "lib/rails_generator/generators/components/migration", "lib/rails_generator/generators/components/model", "lib/rails_generator/generators/components/observer", "lib/rails_generator/generators/components/plugin", "lib/rails_generator/generators/components/resource", "lib/rails_generator/generators/components/scaffold", "lib/rails_generator/generators/components/scaffold_resource", "lib/rails_generator/generators/components/session_migration", "lib/rails_generator/generators/components/web_service", "lib/rails_generator/generators/components/controller/controller_generator.rb", "lib/rails_generator/generators/components/controller/templates", "lib/rails_generator/generators/components/controller/USAGE", "lib/rails_generator/generators/components/controller/templates/controller.rb", "lib/rails_generator/generators/components/controller/templates/functional_test.rb", "lib/rails_generator/generators/components/controller/templates/helper.rb", "lib/rails_generator/generators/components/controller/templates/view.rhtml", "lib/rails_generator/generators/components/integration_test/integration_test_generator.rb", "lib/rails_generator/generators/components/integration_test/templates", "lib/rails_generator/generators/components/integration_test/USAGE", "lib/rails_generator/generators/components/integration_test/templates/integration_test.rb", "lib/rails_generator/generators/components/mailer/mailer_generator.rb", "lib/rails_generator/generators/components/mailer/templates", "lib/rails_generator/generators/components/mailer/USAGE", "lib/rails_generator/generators/components/mailer/templates/fixture.rhtml", "lib/rails_generator/generators/components/mailer/templates/mailer.rb", "lib/rails_generator/generators/components/mailer/templates/unit_test.rb", "lib/rails_generator/generators/components/mailer/templates/view.rhtml", "lib/rails_generator/generators/components/migration/migration_generator.rb", "lib/rails_generator/generators/components/migration/templates", "lib/rails_generator/generators/components/migration/USAGE", "lib/rails_generator/generators/components/migration/templates/migration.rb", "lib/rails_generator/generators/components/model/model_generator.rb", "lib/rails_generator/generators/components/model/templates", "lib/rails_generator/generators/components/model/USAGE", "lib/rails_generator/generators/components/model/templates/fixtures.yml", "lib/rails_generator/generators/components/model/templates/migration.rb", "lib/rails_generator/generators/components/model/templates/model.rb", "lib/rails_generator/generators/components/model/templates/unit_test.rb", "lib/rails_generator/generators/components/observer/observer_generator.rb", "lib/rails_generator/generators/components/observer/templates", "lib/rails_generator/generators/components/observer/USAGE", "lib/rails_generator/generators/components/observer/templates/observer.rb", "lib/rails_generator/generators/components/observer/templates/unit_test.rb", "lib/rails_generator/generators/components/plugin/plugin_generator.rb", "lib/rails_generator/generators/components/plugin/templates", "lib/rails_generator/generators/components/plugin/USAGE", "lib/rails_generator/generators/components/plugin/templates/generator.rb", "lib/rails_generator/generators/components/plugin/templates/init.rb", "lib/rails_generator/generators/components/plugin/templates/install.rb", "lib/rails_generator/generators/components/plugin/templates/plugin.rb", "lib/rails_generator/generators/components/plugin/templates/Rakefile", "lib/rails_generator/generators/components/plugin/templates/README", "lib/rails_generator/generators/components/plugin/templates/tasks.rake", "lib/rails_generator/generators/components/plugin/templates/uninstall.rb", "lib/rails_generator/generators/components/plugin/templates/unit_test.rb", "lib/rails_generator/generators/components/plugin/templates/USAGE", "lib/rails_generator/generators/components/resource/resource_generator.rb", "lib/rails_generator/generators/components/resource/templates", "lib/rails_generator/generators/components/resource/templates/controller.rb", "lib/rails_generator/generators/components/resource/templates/fixtures.yml", "lib/rails_generator/generators/components/resource/templates/functional_test.rb", "lib/rails_generator/generators/components/resource/templates/helper.rb", "lib/rails_generator/generators/components/resource/templates/migration.rb", "lib/rails_generator/generators/components/resource/templates/model.rb", "lib/rails_generator/generators/components/resource/templates/unit_test.rb", "lib/rails_generator/generators/components/resource/templates/USAGE", "lib/rails_generator/generators/components/scaffold/scaffold_generator.rb", "lib/rails_generator/generators/components/scaffold/templates", "lib/rails_generator/generators/components/scaffold/USAGE", "lib/rails_generator/generators/components/scaffold/templates/controller.rb", "lib/rails_generator/generators/components/scaffold/templates/form.rhtml", "lib/rails_generator/generators/components/scaffold/templates/form_scaffolding.rhtml", "lib/rails_generator/generators/components/scaffold/templates/functional_test.rb", "lib/rails_generator/generators/components/scaffold/templates/helper.rb", "lib/rails_generator/generators/components/scaffold/templates/layout.rhtml", "lib/rails_generator/generators/components/scaffold/templates/style.css", "lib/rails_generator/generators/components/scaffold/templates/view_edit.rhtml", "lib/rails_generator/generators/components/scaffold/templates/view_list.rhtml", "lib/rails_generator/generators/components/scaffold/templates/view_new.rhtml", "lib/rails_generator/generators/components/scaffold/templates/view_show.rhtml", "lib/rails_generator/generators/components/scaffold_resource/scaffold_resource_generator.rb", "lib/rails_generator/generators/components/scaffold_resource/templates", "lib/rails_generator/generators/components/scaffold_resource/USAGE", "lib/rails_generator/generators/components/scaffold_resource/templates/controller.rb", "lib/rails_generator/generators/components/scaffold_resource/templates/fixtures.yml", "lib/rails_generator/generators/components/scaffold_resource/templates/functional_test.rb", "lib/rails_generator/generators/components/scaffold_resource/templates/helper.rb", "lib/rails_generator/generators/components/scaffold_resource/templates/layout.rhtml", "lib/rails_generator/generators/components/scaffold_resource/templates/migration.rb", "lib/rails_generator/generators/components/scaffold_resource/templates/model.rb", "lib/rails_generator/generators/components/scaffold_resource/templates/style.css", "lib/rails_generator/generators/components/scaffold_resource/templates/unit_test.rb", "lib/rails_generator/generators/components/scaffold_resource/templates/view_edit.rhtml", "lib/rails_generator/generators/components/scaffold_resource/templates/view_index.rhtml", "lib/rails_generator/generators/components/scaffold_resource/templates/view_new.rhtml", "lib/rails_generator/generators/components/scaffold_resource/templates/view_show.rhtml", "lib/rails_generator/generators/components/session_migration/session_migration_generator.rb", "lib/rails_generator/generators/components/session_migration/templates", "lib/rails_generator/generators/components/session_migration/USAGE", "lib/rails_generator/generators/components/session_migration/templates/migration.rb", "lib/rails_generator/generators/components/web_service/templates", "lib/rails_generator/generators/components/web_service/USAGE", "lib/rails_generator/generators/components/web_service/web_service_generator.rb", "lib/rails_generator/generators/components/web_service/templates/api_definition.rb", "lib/rails_generator/generators/components/web_service/templates/controller.rb", "lib/rails_generator/generators/components/web_service/templates/functional_test.rb", "lib/rails_generator/scripts/destroy.rb", "lib/rails_generator/scripts/generate.rb", "lib/rails_generator/scripts/update.rb", "lib/tasks/databases.rake", "lib/tasks/documentation.rake", "lib/tasks/framework.rake", "lib/tasks/log.rake", "lib/tasks/misc.rake", "lib/tasks/pre_namespace_aliases.rake", "lib/tasks/rails.rb", "lib/tasks/statistics.rake", "lib/tasks/testing.rake", "lib/tasks/tmp.rake"]
  s.rdoc_options = ["--exclude", "."]
  s.executables = ["rails"]
  s.add_dependency(%q<rake>, [">= 0.7.2"])
  s.add_dependency(%q<activesupport>, ["= 1.4.2"])
  s.add_dependency(%q<activerecord>, ["= 1.15.3"])
  s.add_dependency(%q<actionpack>, ["= 1.13.3"])
  s.add_dependency(%q<actionmailer>, ["= 1.3.3"])
  s.add_dependency(%q<actionwebservice>, ["= 1.2.3"])
end