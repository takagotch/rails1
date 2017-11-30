Gem::Specification.new do |s|
  s.name = %q{highline}
  s.version = "1.2.7"
  s.date = %q{2007-01-31}
  s.summary = %q{HighLine is a high-level command-line IO library.}
  s.email = %q{james@grayproductions.net}
  s.homepage = %q{http://highline.rubyforge.org}
  s.rubyforge_project = %q{highline}
  s.description = %q{A high-level IO library that provides validation, type conversion, and more for command-line interfaces. HighLine also includes a complete menu system that can crank out anything from simple list selection to complete shells with just minutes of work.}
  s.has_rdoc = true
  s.authors = ["James Edward Gray II"]
  s.files = ["examples/ansi_colors.rb", "examples/asking_for_arrays.rb", "examples/basic_usage.rb", "examples/color_scheme.rb", "examples/menus.rb", "examples/overwrite.rb", "examples/page_and_wrap.rb", "examples/password.rb", "examples/trapping_eof.rb", "examples/using_readline.rb", "lib/highline.rb", "lib/highline/color_scheme.rb", "lib/highline/import.rb", "lib/highline/menu.rb", "lib/highline/question.rb", "lib/highline/system_extensions.rb", "test/tc_color_scheme.rb", "test/tc_highline.rb", "test/tc_import.rb", "test/tc_menu.rb", "test/ts_all.rb", "Rakefile", "setup.rb", "README", "INSTALL", "TODO", "CHANGELOG", "LICENSE"]
  s.test_files = ["test/ts_all.rb"]
  s.rdoc_options = ["--title", "HighLine Documentation", "--main", "README"]
  s.extra_rdoc_files = ["README", "INSTALL", "TODO", "CHANGELOG", "LICENSE"]
end
