require 'yaml'

require "dot_usage/version"

module DotUsage
  class MarkdownFile
    def initialize(filename)
      @filename = filename
      @contents = File.read filename
    end

    def section(heading)
      after_heading_regexp = /^#{heading}$(?<after>.+)/m
      next_heading_regexp = /(?<section>.+)^#+/m

      after_match_data = after_heading_regexp.match @contents
      raise unless after_match_data

      after_heading = after_match_data[:after]

      before_match_data = next_heading_regexp.match after_heading
      raise unless before_match_data

      @before_match_data[:section]
    end

    def snippet(heading)
      # TODO actually get snippet

      section heading
    end
  end

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
        raise unless 1 == content.length

        md = MarkdownFile.new content.keys.first

        md.snippet content.keys.first
      else
        raise
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
        Command.new(cmd).run(options)
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

    def run_without_prompt(options)
      puts "> Running `#{@cmd}`"

      `#{@cmd}`
    end

    def run_with_prompt(options)
      print "> Run `#{@cmd}` [Y/n]? "

      go = case gets.chomp
      when "y", "Y", "yes", ""
        true
      when "n", "N", "no"
        false
      else
        raise
      end

      if go
        `#{@cmd}`
      else
        puts "Quitting!"
        # TODO
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
