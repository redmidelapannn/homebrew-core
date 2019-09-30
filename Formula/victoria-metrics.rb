class VictoriaMetrics < Formula
  desc "High-performance time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.27.3.tar.gz"
  sha256 "648bf0bbf78357465346923ea5f25b9313dc066419ae30aa67fcfe884fca978a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ed4b0582b3a42aae2f1cb2647e1c33a7c54b9bdbf0f200bbc98c352851b1058" => :catalina
    sha256 "8c2596cddadefd60024d2b2bd435c9f185e0a92a04a7216c3576a4e17518c1b4" => :mojave
    sha256 "108c9e7b4cd174ae448e54a7bf3777368b2fc471844ab88bbdf0d707305adb04" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "bin/victoria-metrics"
  end

  test do
    Open3.popen3("#{bin}/victoria-metrics") do |_, stdout, _, wait_thr|
      sleep 0.5
      begin
        assert_match "build version", stdout.read
      ensure
        Process.kill "TERM", wait_thr.pid
      end
    end
  end
end
