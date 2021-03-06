class Api::V2::SessionsController < Api::BaseController
  before_filter :authenticate_request, :only => [:destroy]

  def create
    user = User.api_authenticate(
      params[:email] || "", params[:password] || ""
    )

    if user
      render json: {
        session: {
          token: user.authentication_token,
          username: user.name,
          organization: user.organization.name
        }
      }
    else
      render status: 401,
        json: { message: "Username and password incorrect" }
    end
  end

  def destroy
    render json: { success: true }
  end
end
