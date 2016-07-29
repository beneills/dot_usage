require 'open3'
require 'yaml'

require "dot_usage/markdown"
require "dot_usage/version"

module DotUsage
  class DotUsageFile
    def initialize(filename)
      @filename = filename
      @data = YAML.load_file filename
    end

    def targets
      @data.keys
    end

    def recipe(target)
      content = @data[target]

      if content.instance_of? Array
        content
      elsif content.instance_of? String
        [content]
      elsif content.instance_of? Hash
        unless 1 == content.length
          STDERR.puts content
          STDERR.puts 'Error: hash may only have one entry!'
          return 1
        end

        md = MarkdownFile.new content.keys.first

        md.snippet content.values.first
      else
        STDERR.puts content
        STDERR.puts 'Error: invalid recipe!'
        1
      end
    end
  end

  class Target
    def initialize(name)
      @name = name
    end

    def recipe(options)
      file = DotUsageFile.new(options.file)

      file.recipe @name
    end

    def run(options)
      recipe(options).each do |cmd|
        status = Command.new(cmd).run(options)

        unless status
          STDERR.puts '> Command failed.  Aborting!'
          return 1
        end
      end

      0
    end
  end

  class Command
    def initialize(cmd)
      @cmd = cmd
    end

    def run(options)
      if options.yes
        run_without_prompt(options)
      else
        run_with_prompt(options)
      end
    end

    private

    def execute(cmd)
      system cmd
    end

    def run_without_prompt(options)
      puts "> Running `#{@cmd}`"

      execute @cmd
    end

    def run_with_prompt(options)
      print "> Run `#{@cmd}` [Y/n]? "

      go = case gets.chomp
      when "y", "Y", "yes", ""
        true
      when "n", "N", "no"
        false
      else
        STDERR.puts '> Invalid choice!'
        false
      end

      if go
        execute @cmd
      else
        puts "Quitting!"
        1
      end
    end
  end

  #
  # List targets
  #
  def self.list_targets(options)
    file = DotUsageFile.new options.file

    puts "Available targets:"
    file.targets.each do |target|
      puts " - #{target}"

      if options.verbose
        Target.new(target).recipe(options).each do |cmd|
          puts "     `#{cmd}`"
        end
      end
    end

    0
  end

  #
  # Run a given target
  #
  def self.run_target(target, options)
    target = Target.new target

    target.run options
  end
end
