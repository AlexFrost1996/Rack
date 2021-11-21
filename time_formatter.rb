# frozen_string_literal: true

class TimeFormatter
  TIME_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(formats)
    @formats = formats.split(',')
    @unknown_time_foramt = []
  end

  def call
    @formats.each do |format| 
      @unknown_time_format << format unless TIME_FORMATS.key?(format)
      @output_format << TIME_FORMATS[format] if TIME_FORMATS.include?(format)
    end
  end

  def success?
    @unknown_time_format.empty?
  end

  def time_string
    Time.now.strftime(@output_format.join('-'))
  end

  def invalid_string
    "Unknown time format #{@unknown_time_format}" unless success?
  end
end
