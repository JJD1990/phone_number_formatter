require 'formatter'

RSpec.describe Formatter::PhoneNumber::UK do
  describe '.format' do
    context 'with valid phone numbers' do
      it 'formats a number starting with 07 to +447' do
        expect(described_class.format('07123456789')).to eq('+447123456789')
      end

      it 'formats a number starting with 44 to +447' do
        expect(described_class.format('447123456789')).to eq('+447123456789')
      end

      it 'formats a number starting with +447 correctly' do
        expect(described_class.format('+447123456789')).to eq('+447123456789')
      end

      it 'removes spaces and formats the number' do
        expect(described_class.format('07123 456 789')).to eq('+447123456789')
      end

      it 'handles leading and trailing spaces' do
        expect(described_class.format('  07123456789  ')).to eq('+447123456789')
      end
    end

    context 'with invalid phone numbers (raw input)' do
      it 'raises an error for numbers shorter than 7 digits (raw input)' do
        expect { described_class.format('071') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Phone number is too short'
        )
      end

      it 'raises an error for numbers longer than 15 digits (raw input)' do
        expect { described_class.format('071234567890123456') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Phone number is too long'
        )
      end

      it 'raises an error for numbers with letters' do
        expect { described_class.format('07123abc6789') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Phone number must only contain digits'
        )
      end

      it 'raises an error for numbers with special characters' do
        expect { described_class.format('07123-456-789') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Phone number must only contain digits'
        )
      end

      it 'raises an error for numbers with invalid prefixes' do
        expect { described_class.format('06343434343') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Must be a UK phone number prefix +44'
        )
      end

      it 'raises an error for international numbers with invalid country codes' do
        expect { described_class.format('+47 123456789') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Must be a UK phone number prefix +44'
        )
      end
    end

    context 'with invalid formatted phone numbers' do
      # Bypass raw input validation by providing correctly formatted inputs
      it 'raises an error for formatted numbers too short for +447 format' do
        wrong_input = '+447123'
        expect { described_class.format(wrong_input) }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Phone number is too short for +447 format'
        )
      end

      it 'raises an error for formatted numbers too long for +447 format' do
        wrong_input = '+447123456789123'
        expect { described_class.format(wrong_input) }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Phone number is too long for +447 format'
        )
      end      
    end

    context 'with edge cases' do
      it 'raises an error for an empty string' do
        expect { described_class.format('') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Please enter a phone number'
        )
      end

      it 'raises an error for nil input' do
        expect { described_class.format(nil) }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Please enter a phone number'
        )
      end

      it 'raises an error for numbers with only spaces' do
        expect { described_class.format('     ') }.to raise_error(
          Formatter::PhoneNumber::InvalidNumberError, 'Invalid phone number: Please enter a phone number'
        )
      end
    end
  end
end
