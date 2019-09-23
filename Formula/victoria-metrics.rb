class VictoriaMetrics < Formula
  desc "High-performance time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.27.3.tar.gz"
  sha256 "648bf0bbf78357465346923ea5f25b9313dc066419ae30aa67fcfe884fca978a"

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
