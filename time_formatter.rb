class TimeFormatter
  attr_reader :result

  TIME_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(formats)
    @formats = formats.split(",")
    @time = Time.now
    @success = false
    @unknown_time_foramt = []
    @result = ""
  end

  def call
    @formats.each { |format| take_unknown_format(format) } 
    @success = @unknown_time_format.empty?
    return @result = ("Unknown time format #{@unknown_time_format}") unless @success
    output_format = make_output_format(@formats)
    @result = @time.strftime(output_format)
  end

  def success?
    @success
  end

  private

  def take_unknown_format(format)
    @unknown_time_format << format unless TIME_FORMATS.has_key?(format)
  end

  def make_output_format(formats)
    @formats.each { |format|
      if TIME_FORMATS.include?(format)
        result << "-" unless result.empty?
        result << TIME_FORMATS[format]
      end
    }
    result
  end
end
