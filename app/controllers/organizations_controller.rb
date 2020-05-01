class OrganizationsController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :authenticate_admin!, except: :show

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  private

  def current_organization
    @_current_organization ||= Organization.find(params[:id]) if params[:id]
  end
end