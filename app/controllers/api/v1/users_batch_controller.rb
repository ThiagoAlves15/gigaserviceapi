module Api
  module V1
    class UsersBatchController < ApplicationController
      def create
        if User.count > 100
          redirect_to users_path, notice: 'User limit reached.'
          return
        end

        response = HTTP.get(
          'https://randomuser.me/api/',
          params: {
            format: 'json',
            results: 30,
            inc: 'gender, name, email, picture, nat',
            nat: 'br',
            seed: 'giga'
          }
        )

        result = CreateUsers.call(response.parse) if response.status.success?

        if result.success?
          redirect_back_or_to users_path, status: 303, notice: 'New users added.'
        else
          redirect_back_or_to users_path, status: :unprocessable_entity, notice: result.error
        end
      end
    end
  end
end
