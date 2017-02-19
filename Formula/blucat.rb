class Blucat < Formula
  desc "netcat for Bluetooth"
  homepage "https://blucat.sourceforge.io"
  url "https://github.com/ieee8023/blucat/archive/v0.91.tar.gz"
  sha256 "3e006d25b7e82689826c89ffbbfa818f8b78cced47e6d0647e901578d330a2f4"
  head "https://github.com/ieee8023/blucat.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "166b5dc50dce7eb911f607b4eba9775062d6ddf583c2851ce5424f4d89566102" => :yosemite
  end

  depends_on "ant" => :build
  depends_on :java => "1.6+"

  def install
    system "ant"
    libexec.install "blucat"
    libexec.install "lib"
    libexec.install "build"
    bin.write_exec_script libexec/"blucat"
  end

  test do
    begin
      io = IO.popen("#{bin}/blucat scan 0")
      sleep 1
      assert_equal "#Scanning RFCOMM Channels 1-30", io.gets.strip
    ensure
      Process.kill "TERM", io.pid
      Process.wait io.pid
    end
  end
end
