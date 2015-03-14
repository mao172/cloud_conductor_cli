require 'formatador'
require 'json'
require 'active_support/core_ext/string'

module CloudConductorCli
  module Helpers
    module Output
      def display_message(message, indent_level: 0, indent_spaces: 2)
        indent = ' ' * indent_level * indent_spaces
        puts indent + message
      end

      def display_list(data, exclude_keys: [])
        display_data = convert_string(data)
        display_data = filter(display_data, exclude_keys) unless exclude_keys.empty?
        if display_data.empty?
          display_message 'No records'
        else
          Formatador.display_compact_table(display_data, display_data.first.keys)
        end
      end

      def display_details(data, exclude_keys: [])
        display_data = convert_string(data)
        display_data = filter(display_data, exclude_keys) unless exclude_keys.empty?
        display_data = verticalize(display_data)
        Formatador.display_compact_table(display_data)
      end

      # convert false to 'false' and truncate long text
      def convert_string(data, max_length = 80)
        case data
        when Hash
          data.each_with_object({}) do |(key, val), new_hash|
            new_hash[key] = convert_string(val)
          end
        when Array
          data.map { |obj| convert_string(obj) }
        else
          data.to_s.truncate(max_length, separator: /\s/).gsub(/(\r\n|\r|\n)/, '\n')
        end
      end

      def verticalize(data)
        return data unless data.is_a? Hash
        data.map do |key, value|
          { property: key, value: value }
        end
      end

      def filter(data, exclude_keys = [])
        case data
        when Array
          data.map do |record|
            record.reject { |key, _value| exclude_keys.include?(key) }
          end
        when Hash
          data.reject { |key, _value| exclude_keys.include?(key) }
        else
          data
        end
      end

      def error_exit(message, response = nil, exit_code = 1)
        warn "Error: #{message}"
        warn "#{JSON.parse(response.body)['message']}" if response
        exit exit_code
      rescue JSON::ParserError
        warn response.body if response
        exit exit_code
      end

      def normal_exit(message = nil, exit_code = 0)
        display_message message if message
        exit exit_code
      end
    end
  end
end
