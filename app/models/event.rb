class Event
  attr_reader :not_invited
  attr_reader :invited
  def initialize graph, event_id
    @graph = graph
    @event_id = event_id
    @invited = @graph.get_connections(event_id, "invited").map{|i| i["id"] }
    @not_invited = []
  end

  def invite people_ids
    people_ids.select{|p| !@invited.include? p}.each_slice(400).to_a.all? {|p| do_invite p}
  end

  protected
  def do_invite people_ids
    @graph.put_connections(@event_id, "invited", users: people_ids.join(","))
  rescue
    if people_ids.length == 1
      @not_invited << people_ids[0]
      true
    else
      left = people_ids[0, ( people_ids.size / 2.0 ).round]
      right = people_ids - left
      do_invite(left) && do_invite(right)
    end
  end
end