class Movie < ActiveRecord::Base
  scope :ordered, -> {order(title: :asc)}
  validates_presence_of :daemon_id

  def daemon
    Application::DAEMON
  end

  def play
    movie_files.each do |file|
      Omxplayer.instance.open(filename: file, audio_output: 'hdmi')
    end
  end

  def details
    daemon.get_torrent_status(daemon_id, ['progress'])
  end

  def movie_files
    Dir.glob("#{path}/**/*[.mp4, .avi, .mkv, .h264, .mov, .wmv, .vob]")
  end

  def progress
    value = details['progress'].round(1)
    update_column(:completed, true) if value == 100
    if completed
      100.0
    else
      value
    end
  end

  def as_json(opts={})
    {id: id, progress: progress}
  end
end
