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
    can :read, Trip, public: true
    can :read, Note, trip: { public: true }
  end

  def user
    guest

    alias_action :create, :read, :update, :destroy, to: :crud

    can :create, Trip
    can [:crud], Trip, user_id: @user.id
    can [:my], Trip, user_id: @user.id

    can [:crud], Note, trip: { user_id: @user.id }
  end
end
