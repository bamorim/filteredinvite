class InviteController < ApplicationController
  def index
    p params[:event].nil? ? nil : params[:event][:id]
    @friends = current_user.friends.filter_by(params["filters"] || {}).to_hash if user_signed_in?
  end

  def invite
    redirect_to :root if !user_signed_in?
    friends = current_user.friends.filter_by(params["filters"] || {})
    to_invite = friends.to_hash.map{|f| f["id"] }
    to_invite.select!{|f| !current_user.blacklist.include? f}
    event = Event.new current_user.graph, params[:event][:id]
    result = event.invite to_invite
    unless event.not_invited.empty?
      current_user.blacklist = (current_user.blacklist + event.not_invited).uniq
      current_user.save
    end
    render json: {invited: result, not_invited: event.not_invited, blacklist: current_user.blacklist}
  end
end
