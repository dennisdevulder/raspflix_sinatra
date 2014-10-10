class Movie < ActiveRecord::Base
  scope :ordered, -> {order(title: :asc)}

  def daemon
    Application::DAEMON
  end

  def play
    movie_files.each do |file|
      # system "#{ENV['VLC_EXECUTABLE_PATH']} #{path}"
      system "omxplayer -o hdmi -r '#{file}'"
    end
  end

  def details
    daemon.get_torrent_status(daemon_id, ['progress'])
  end

  def movie_files
    Dir.glob("#{path}**/*[.mp4, .avi, .mkv, .h264, .mov, .wmv, .vob]")
  end

  def progress
    unless completed
      details['progress'].round(1)
    else
      100.0
    end
  end
end
