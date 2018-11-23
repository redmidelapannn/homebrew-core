class Avgtime < Formula
  desc "Like unix 'time' command, but with repetitions, median, std deviation"
  homepage "https://github.com/jmcabo/avgtime"
  url "https://github.com/jmcabo/avgtime.git", :revision => "ffdf20049db7a6aa6074354d95265869c6aad65b"
  version "0.6.0-dev"

  bottle do
    sha256 "254e179967e9edf7460403d86e6e14e474a427c4fa86aeb27919963f7109d66d" => :high_sierra
    sha256 "465e1823784549e9059810194e2b0f6ae6f484bab0606e343ceacf7dac818558" => :sierra
  end

  depends_on "dmd" => :build

  def install
    system "dmd", "./avgtime.d"
    bin.install "avgtime"
  end

  test do
    system "#{bin}/avgtime", "-r", "10", "ls"
  end
end
