module Api
  module V1
    class UsersController < ApplicationController
      def create
        if User.count > 100
          redirect_to users_path, notice: "User limit reached."
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

        if response.status.success?
          CreateUsers.call(response.parse)

          redirect_to users_path, status: 200
        else
          render :unprocessable_entity
        end
      end
    end
  end
end