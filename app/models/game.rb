class Game < ActiveRecord::Base
  has_many :scores
  has_many :users, :through => :scores
  has_many :userposts
  has_many :game_events, dependent: :destroy
  belongs_to :league


  validates_presence_of :name
  validates_length_of :name, maximum: 30, message: "30 characters max for game name"


  def belongs_to_game?(user_id)
      users.find(user_id)
  end

  def leader
    self.include("scores").where(maximum("points")).name
  end

  def ordered_scores
    scores.order('points DESC')
  end

  def points user
    score = self.scores.where(:user_id => user.id).first
    if score.nil?
      "N/A"
    else
      score.points
    end
  end

  def position user
    @rank = Score.find_by_sql("select (select  count(*)+1 from scores as s2 where s2.points > s1.points and game_id = :game_id) as UserRank from scores as s1 WHERE game_id = :game_id and user_id = :user_id", {game_id: self.id, user_id: user.id})
    if @rank.empty?
      "N/A"
    else
      @rank[0].UserRank
    end
  end

  def active_event_votes(current_user_id)
    @event_votes = Array.new
    game_events.active.each do |game_event|
      @event_votes += game_event.event_votes.where(user_id: current_user_id)
    end
    @event_votes
  end

  def inactive_event_votes(current_user_id)
    @event_votes = Array.new
    game_events.each do |game_event|
      @event_votes += game_event.event_votes.where(user_id: current_user_id)
    end
    @event_votes
  end

end
