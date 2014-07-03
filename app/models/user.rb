class User < ActiveRecord::Base
  attr_accessible :name, :provider, :token, :uid

  def self.find_or_create_with_omniauth auth
    user = find_by_provider_and_uid(auth["provider"], auth["uid"]).tap do |u|
      u.update_attributes(:token => auth["credentials"]["token"]) if u
    end
    user || create_with_omniauth(auth)
  end

  def events
    events = Rails.cache.fetch "user/#{uid}/events", expires_in: 10.minutes do
      graph.get_connections "me", "events"
    end
    events.map{|e| [e["name"], e["id"]]}
  end

  def friends(filters={})
    hash = Rails.cache.read "user/#{uid}/friends"
    friends = Friends.new graph, hash
    Rails.cache.write "user/#{uid}/friends", friends.to_hash, expires_in: 12.hours
    friends
  end

  def graph
    @graph ||= Koala::Facebook::API.new(token)
  end

  def blacklist= val
    write_attribute(:blacklist, val.to_json)
  end

  def blacklist
    JSON.parse read_attribute(:blacklist)
  rescue
    write_attribute(:blacklist, "[]")
    []
  end

private
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid      = auth["uid"]
      user.provider = auth["provider"]
      user.email    = auth["info"]["email"]
      user.name     = auth["info"]["name"]
      user.token    = auth["credentials"]["token"]
    end
  end
end
