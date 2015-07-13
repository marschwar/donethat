class Ability
  include CanCan::Ability

  def initialize(current_user)
    @user = current_user
    if @user.present?
      user
    else
      guest
    end
  end

private
  def guest

  end

  def user
    guest
    can :create, Trip
    can [:manage], Trip do |trip|
      trip.owned_by @user
    end
  end
end
