class Movie < ActiveRecord::Base
  scope :ordered, -> {order(title: :asc)}
  validates_presence_of :daemon_id

  def play
    movie_files.each do |file|
      Omxplayer.instance.open "#{file}"
    end
  end
end
