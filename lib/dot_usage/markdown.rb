INDENTATION = "    "

class MarkdownFile
  def initialize(filename)
    @filename = filename
    @contents = File.read filename
  end

  def section(heading)
    after_heading_regexp = /^#{heading}$(?<after>.+)/m
    next_heading_regexp = /(?<section>.+)^#+/m

    after_match_data = after_heading_regexp.match @contents
    return nil unless after_match_data

    after_heading = after_match_data[:after]

    before_match_data = next_heading_regexp.match after_heading
    return nil unless before_match_data

    before_match_data[:section]
  end

  def snippet(heading)
    s = section heading
    return nil if s.nil?

    [extract_quoted_snippet(s), extract_indented_snippet(s)].select { |r| ! r.nil? }.first
  end

  private

  # Try to extract a triple quoted snippet from the section
  #
  # Otherwise, return nil
  def extract_quoted_snippet(section)
    quoted_snipped_regexp = /^```\S*$(?<quoted_snippet>.+?)^```$/m

    match_data = quoted_snipped_regexp.match(section)

    if match_data
      match_data[:quoted_snippet].strip.split "\n"
    else
      nil
    end
  end

  # Try to extract an indented snippet from the section
  #
  # Otherwise, return nil
  def extract_indented_snippet(section)
    indentation_regexp = /^(?<after>#{INDENTATION}.+)$/m

    match_data = indentation_regexp.match(section)

    if match_data
      match_data[:after].lines.take_while { |line| line.strip.empty? or line.start_with? INDENTATION }.map { |l| l.strip }.select { |l| ! l.empty?}
    else
      nil
    end
  end
end
