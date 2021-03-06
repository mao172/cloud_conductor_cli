require 'thor'

module CloudConductorCli
  module Models
    class Account < Thor
      include Models::Base

      desc 'list', 'List accounts'
      def list
        response = connection.get('/accounts')
        output(response)
      end

      desc 'show ACCOUNT', 'Show account details'
      def show(account)
        id = find_id_by(:account, :email, account)
        response = connection.get("/accounts/#{id}")
        output(response)
      end

      desc 'create', 'Create new account'
      method_option :email, type: :string, required: true, desc: 'Account email'
      method_option :name, type: :string, required: true, desc: 'Account user name'
      method_option :password, type: :string, required: true, desc: 'Account password'
      method_option :admin, type: :boolean, desc: 'Admin or not', default: false
      def create
        payload = declared(options, self.class, :create)
                  .merge('password_confirmation' => options['password'],
                         'admin' => options['admin'] ? 1 : 0)
        response = connection.post('/accounts', payload)

        message('Create completed successfully.')
        output(response)
      end

      desc 'update ACCOUNT', 'Update account'
      method_option :email, type: :string, desc: 'Account email'
      method_option :name, type: :string, desc: 'Account user name'
      method_option :password, type: :string, desc: 'Account password'
      method_option :admin, type: :boolean, desc: 'Admin or not', default: false
      def update(account)
        id = find_id_by(:account, :email, account)
        payload = declared(options, self.class, :update)
                  .merge('password_confirmation' => options['password'],
                         'admin' => options['admin'] ? 1 : 0)
        response = connection.put("/accounts/#{id}", payload)

        message('Update completed successfully.')
        output(response)
      end

      desc 'delete ACCOUNT', 'Delete account'
      def delete(account)
        id = find_id_by(:account, :email, account)
        connection.delete("/accounts/#{id}")

        message('Delete completed successfully.')
      end
    end
  end
end
