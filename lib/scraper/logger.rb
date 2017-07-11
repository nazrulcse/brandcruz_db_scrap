class Logger
  def self.log_write(file, content, option = 'a')
    File.open(file, option) do |f|
      f.puts content
    end
  end
end