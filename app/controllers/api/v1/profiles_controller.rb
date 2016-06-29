class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    @profiles = User.where.not(id: current_resource_owner.id)
    respond_with @profiles
  end
end
