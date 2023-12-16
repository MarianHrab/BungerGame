# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
  
    def edit
      # Check if the user already has a profile
      @profile = @user.profile || @user.build_profile
    end
  
    def update
      @profile = @user.profile || @user.build_profile
      if @profile.update(profile_params)
        redirect_to profile_path, notice: 'Profile updated successfully.'
      else
        render :edit
      end
    end
  
    private
  
    def set_user
      @user = current_user
    end
  
    def profile_params
      params.require(:profile).permit(:name, :avatar)
    end
  end
  