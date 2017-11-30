@echo off
goto endofruby
#!/bin/ruby

update_dir = $LOAD_PATH.find { |fn| fn =~ /rubygems-update/ }

if update_dir.nil?
  puts "Error: Cannot find RubyGems Update Path!"
  puts 
  puts "RubyGems has already been updated."
  puts "The rubygems-update gem may now be uninstalled."
  puts "E.g.    gem uninstall rubygems-update"
else
  update_dir = File.dirname(update_dir)
  Dir.chdir update_dir
  update_dir =~ /([0-9.]*)$/
  RGVERSION = $1
  puts "Installing RubyGems #{RGVERSION}"
  system "ruby setup.rb #{ARGV.join(' ')}"
end

__END__
:endofruby
"%~d0%~p0ruby" -x "%~f0" %*