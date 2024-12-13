module Formatter
  module PhoneNumber
    # Custom error class for handling invalid phone number errors
    class InvalidNumberError < StandardError; end

    # Formatter for UK phone numbers
    module UK
      # Main method to format a UK phone number
      #
      # This method handles the entire phone number formatting process. It sanitizes the input,
      #   validates the characters and length, transforms the prefix to the standard UK format (+447),
      #   and validates the final length of the formatted phone number.
      #
      # @param [String] number The phone number to be formatted
      # @return [String] Formatted phone number in +447 format
      def self.format(number)
        sanitized_number = sanitize(number)
        validate_raw_input(sanitized_number)

        # Transform the prefix to normalize the format
        formatted_number = transform_prefix(sanitized_number)

        # Validate the final formatted length
        validate_final_format(formatted_number)

        formatted_number
      end

      class << self
        private

        # This method ensures that the input number is treated as a string, removes leading
        #   and trailing spaces, and deletes internal spaces. It raises an error if the input is empty.
        #
        # @param [String, Integer, nil] number The phone number input
        # @return [String] Sanitized phone number
        def sanitize(number)
          sanitized = number.to_s.strip.delete(' ')
          raise InvalidNumberError, 'Invalid phone number: Please enter a phone number' if sanitized.empty?

          sanitized
        end

        # This method checks the input phone number for valid characters and length.
        # It raises an error if the number contains invalid characters or has an incorrect length.
        #
        # @param [String] number The sanitized phone number
        # @raise [InvalidNumberError] if the number contains any characters other than digits or a '+'
        # @raise [InvalidNumberError] if the length of the number is too short or too long
        def validate_raw_input(number)
          raise InvalidNumberError,
            'Invalid phone number: Phone number must only contain digits' if number.count('^0-9+') > 0

          # Skip raw length validation for inputs starting with +447 (final format check will handle it)
          return if number.start_with?('+447')

          if number.length < 11
            raise InvalidNumberError, 'Invalid phone number: Phone number is too short'
          elsif number.length > 15
            raise InvalidNumberError, 'Invalid phone number: Phone number is too long'
          end

          # Ensure the phone number has a valid UK prefix
          unless number.start_with?('07', '447', '+447')
            raise InvalidNumberError, 'Invalid phone number: Must be a UK phone number prefix +44'
          end
        end

        # This method ensures that phone numbers starting with "07", "447", or "+447" are properly formatted.
        #
        # @param [String] number The sanitized phone number
        # @return [String] Phone number with corrected prefix
        # @raise [InvalidNumberError] if the prefix is not valid
        def transform_prefix(number)
          case number
          when /\A07/ then number.sub('07', '+447')
          when /\A447/ then number.sub('447', '+447')
          when /\A\+447/ then number
          else
            raise InvalidNumberError, 'Invalid phone number: Must be a UK phone number prefix +44'
          end
        end

        # Validates the final formatted phone number to ensure it is exactly 13 characters long
        #
        # @param [String] number The formatted phone number
        # @raise [InvalidNumberError] if the formatted number is not exactly 13 characters
        def validate_final_format(number)
          if number.size < 13
            raise InvalidNumberError, 'Invalid phone number: Phone number is too short for +447 format'
          elsif number.size > 13
            raise InvalidNumberError, 'Invalid phone number: Phone number is too long for +447 format'
          end
        end
      end
    end
  end
end
