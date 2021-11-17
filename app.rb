require_relative 'time_formatter'

class App
  WRONG_REQUEST_ERROR = 'Only GET request supported'
  PAGE_NOT_FOUND_ERROR = 'Page not found'
  PARAMETER_NOT_FOUND_ERROR = 'Format parameter not found'

  def call(env)
    @env = env
    response = check_request
    response = get_time if response.nil?

    [response[:status], headers, response[:body]]
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def get_time
    formats = take_formats
    time_formatter = TimeFormatter.new(formats)
    time_formatter.call
    return send_response(time_formatter.result, 400) unless time_formatter.success?
    send_response(time_formatter.result, 200)
  end

  def check_request
    return send_response(WRONG_REQUEST_ERROR, 404) if @env['REQUEST_METHOD'] != 'GET'
    return send_response(PAGE_NOT_FOUND_ERROR, 404) if @env['REQUEST_PATH'] != '/time'
    return send_response(PARAMETER_NOT_FOUND_ERROR, 404) unless get_formats
  end

  def take_formats
    Rack::Utils.parse_nested_query(@env['QUERY_STRING'])["format"]
  end

  def send_response(status, body)
    {status: status, body: [body + "\n"] }
  end
end
