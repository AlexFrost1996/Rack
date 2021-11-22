# frozen_string_literal: true

require_relative 'time_formatter'

class App
  PAGE_NOT_FOUND_ERROR = 'Page not found'

  def call(env)
    @env = env
    if @env['REQUEST_METHOD'] == 'GET' && @env['REQUEST_PATH'] == '/time'
      handle_request
    else
      send_response(PAGE_NOT_FOUND_ERROR, 404)
    end
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def handle_request
    formats = take_formats
    time_formatter = TimeFormatter.new(formats)
    time_formatter.call
    if time_formatter.success?
      send_response(time_formatter.time_string, 200)
    else
      send_response(time_formatter.invalid_string, 400)
    end
  end

  def take_formats
    Rack::Utils.parse_nested_query(@env['QUERY_STRING'])['format']
  end

  def send_response(body, status)
    Rack::Response.new(body, status, headers).finish
  end
end
