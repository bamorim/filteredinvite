class Friends
  RELATIONSHIP_STATUS = ["Single", "In a relationship", "Engaged", "Married", "It's complicated", "In an open relationship", "Widowed", "Separated", "Divorced", "In a civil union", "In a domestic partnership"]
  @@friend_fields = "id,name,gender,relationship_status,birthday"

  def initialize graph, hash = nil
    @graph = graph
    @hash = hash || graph.get_connections("me", "friends", "fields" => @@friend_fields)
  end

  def to_hash
    @hash
  end

  def filter_by filters={}
    dup.filter_by! filters
  end

  def filter_by! filters={}
    if filters[:relationship_status]
      filters[:relationship_status].map!{|r| r if r != "nil"}
      @hash.select! {|f| filters[:relationship_status].include? f["relationship_status"] }
    end

    if filters.has_key?(:gender) && filters[:gender] != "Any"
      @hash.select! {|f| f["gender"] == filters[:gender]}
    end

    if filters.has_key?(:age_from)
      @hash.select! {|f| age(f["birthday"]) && age(f["birthday"]) >= filters[:age_from].to_i}
    end

    if filters.has_key?(:age_to) && filters[:age_to].to_i > 0
      @hash.select! {|f| age(f["birthday"]) && age(f["birthday"]) <= filters[:age_to].to_i} 
    end

    self
  end

protected

  def age(birthday_string)
    return false if birthday_string.nil?
    birthday = birthday_string.split("/").reverse.collect{|x| x.to_i}
    return false if birthday.length < 3
    Date.today.year - birthday[0] - ((birthday[1] > Date.today.month || (birthday[1] = Date.today.month && birthday[2] > Date.today.day)) ? 1 : 0)
  end  
end