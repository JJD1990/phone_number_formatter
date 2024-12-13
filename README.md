## Phone Number Formatter Solution Explanation
===========================================

## Ruby Methods vs. Regex

Initially, regex seemed like a natural fit for validating and transforming the phone number. However, after reviewing
the requirements and reflecting on Ruby's built-in methods, I decided to use Ruby's native methods where possible.

For example, I used .strip and .delete(' ') to sanitize the phone number by removing spaces, instead of writing a
complex regex pattern to handle spaces. Also, methods like .count were used to check if the phone number contains
invalid characters, ensuring that only digits and a single + sign were allowed.
    
## Validating Raw vs. Formatted Numbers

I decided to validate the phone number twice, once on the raw input and again on the formatted result, this could be
seen as overkill but in my current role we often have mismatches between what our application sees as valid but our
API endpoint does not. This results in support tickets and is inefficient. 
    
## Table of Valid and Invalid Phone Numbers

Below is a table that summarizes the validation rules for the UK phone number formatter:

| Phone Number | Valid/Invalid | Reason |
|---------------|---------------|--------|
| `07123456789` | Valid         | Correct length, starts with `07`, valid prefix |
| `447123456789` | Valid         | Correct length, starts with `447`, valid prefix |
| `+447123456789` | Valid         | Correct length, starts with `+447`, valid prefix |
| `07123 456 789` | Valid         | Correct length, spaces removed, valid prefix |
| `+447123` | Invalid       | Too short after transformation, not 13 characters long |
| `071234567890123` | Invalid       | Too long after transformation, exceeds 13 characters |
| `07123abc6789` | Invalid       | Contains letters, invalid characters |
| `07123-456-789` | Invalid       | Contains special characters, invalid format |
| `06343434343` | Invalid       | Invalid prefix, must start with `07`, `447`, or `+447` |
| `+47 123456789` | Invalid       | Invalid international prefix, must start with `+44` |

## Conclusion

This solution formats and validates UK phone numbers whilst ensuring edge cases are handled. By opting to use Ruby
methods over regex where possible, I prioritized readability and maintainability. It meets standard Ruby best practices.
Additionally, the two validations ensure the API is kept happy.

## Further progression - Support for Multiple Countries

Currently, the module only handles UK phone numbers. However, phone number formatting rules vary from country to
country. To make this solution more scalable, it would be beneficial to refactor the formatter into a more flexible 
design that can handle phone numbers from different countries. As Butternut Box is expanding into other countries I 
imagine this is already a solution you have in production!

#### Potential Approach:
A scalable approach would involve creating a `PhoneNumberFormatter` class with country-specific modules (e.g., `UK`,
`PL`, `DE` for Germany, etc.) that encapsulate the formatting rules for each country. The formatter could accept a 
`country_code` parameter, and based on this, it would select the appropriate module to format the phone number. 
The solution would be more flexible, as additional countries can be added without changing the core logic. 
The country-specific modules would each encapsulate the rules and exceptions for a given country's phone numbers.

#### Example Code:

```ruby
module Formatter
  module PhoneNumber
    class PhoneNumberFormatter
      def self.format(number, country_code)
        case country_code
        when 'GB'  # UK
          Formatter::PhoneNumber::UK.format(number)
        when 'PL'  # Poland
          Formatter::PhoneNumber::PL.format(number)
        when 'DE'  # Germany
          Formatter::PhoneNumber::DE.format(number)
        else
          raise InvalidNumberError, 'Country not supported'
        end
      end
    end
  end
end

module Formatter
  module PhoneNumber
    module PL
      def self.format(number)
      end
    end
  end
end
```