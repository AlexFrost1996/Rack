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
    @output_format = []
  end

  def call
    @formats.each do |format| 
      if TIME_FORMATS[format]
        @output_format << TIME_FORMATS[format]
      else
        @unknown_time_format << format
      end
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
