module CloudConductorCli
  module Helpers
    describe Outputter do
      before do
        @output = Object.new
        @output.extend(Outputter)
        allow(@output).to receive(:puts)
        allow(@output).to receive_message_chain(:outputter, :message)
        allow(@output).to receive_message_chain(:outputter, :output)
      end

      describe '#output' do
        it 'call output method for outputter instance' do
          expect(@output).to receive_message_chain(:outputter, :output).with('dummy response')

          @output.output 'dummy response'
        end
      end

      describe '#message' do
        it 'call message method for outputter instance' do
          expect(@output).to receive_message_chain(:outputter, :message).with('    dummy message')

          @output.message 'dummy message', indent_level: 1, indent_spaces: 4
        end
      end

      describe '#error_exit' do
        before do
          allow(@output).to receive(:warn)
          allow(@output).to receive(:exit)
        end

        it 'call warn with message' do
          expect(@output).to receive(:warn).with('Error: dummy message')

          @output.error_exit('dummy message')
        end

        it 'call warn with message of response body' do
          expect(@output).to receive(:warn).with('dummy response')

          response = double(:response, body: '{ "message": "dummy response"}')
          @output.error_exit('dummy message', response)
        end

        it 'call warn with plain body if response body is invalid JSON string' do
          expect(@output).to receive(:warn).with('dummy error response')

          response = double(:response, body: 'dummy error response')
          @output.error_exit('dummy message', response)
        end

        it 'exit with specified exit_code' do
          expect(@output).to receive(:exit).with(2)

          @output.error_exit('dummy message', nil, 2)
        end
      end

      describe '#normal_exit' do
        before do
          allow(@output).to receive(:exit)
        end

        it 'display the passed message on the screen' do
          expect(@output).to receive(:puts).with('dummy message')

          @output.normal_exit('dummy message')
        end

        it 'exit with specified exit_code' do
          expect(@output).to receive(:exit).with(1)

          @output.normal_exit('dummy message', 1)
        end
      end
    end
  end
end
