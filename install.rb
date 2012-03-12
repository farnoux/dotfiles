#!/usr/bin/env ruby
 
# from http://errtheblog.com/posts/89-huba-huba 
home = ENV['HOME']
replace_all = false
 
Dir.chdir File.dirname(__FILE__) do
  # dotfiles_dir = Dir.pwd.sub(home + '/', '')
  dotfiles_dir = Dir.pwd
  
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE install.rb].include? file
    link_file = true

    target = File.join(home, ".#{file}")
    puts "Target: #{target}, File: #{file}"
    if File.exist? target and not replace_all
      if File.identical? file, target
        puts "identical ~/.#{file}"
        link_file = false
      elsif not replace_all
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
        when 'y', 'a'
          # system %[rm -rf $HOME/.#{file}]
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
          link_file = false
        end
      end
    end
    if link_file
      puts "Command: #{%[ln -vsf #{File.join(dotfiles_dir, file)} #{target}]}"
      system %[ln -vsf #{File.join(dotfiles_dir, file)} #{target}]
    end
  end
end