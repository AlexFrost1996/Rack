# frozen_string_literal: true

require_relative 'time_formatter'

class App
  attr_reader :time_formatter
  
  WRONG_REQUEST_ERROR = 'Only GET request supported'
  PAGE_NOT_FOUND_ERROR = 'Page not found'
  PARAMETER_NOT_FOUND_ERROR = 'Format parameter not found'

  def call(env)
    @env = env
    take_time
    choose_response
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def take_time
    formats = take_formats
    time_formatter = TimeFormatter.new(formats)
    time_formatter.call
  end

  def choose_response
    return send_response(WRONG_REQUEST_ERROR, 404) if @env['REQUEST_METHOD'] != 'GET'
    return send_response(PAGE_NOT_FOUND_ERROR, 404) if @env['REQUEST_PATH'] != '/time'
    return send_response(PARAMETER_NOT_FOUND_ERROR, 404) unless take_formats
    return send_response(time_formatter.invalid_string, 400) unless time_formatter.success?
    send_response(time_formatter.time_string, 200)
  end

  def take_formats
    Rack::Utils.parse_nested_query(@env['QUERY_STRING'])['format']
  end

  def send_response(status, body)
    Rack::Response.new(body, status, headers).finish
  end
end
