class Blucat < Formula
  desc "netcat for Bluetooth"
  homepage "http://blucat.sourceforge.net/blucat/"
  url "http://blucat.sourceforge.net/blucat/wp-content/uploads/blucat-aa3e02.zip"
  version "0.9"
  sha256 "6dcd6bf538a06c2f29d21a9e94d859d91667a7014244462bffca9767bba5307d"

  bottle do
    cellar :any
    sha256 "f1faf0f8ddefe8bf4199c912a670403d7079667593b2a9a5a962f505008082a8" => :yosemite
    sha256 "e9430662b8d062f60c15f048b4738476bc23c0273c85d43b43d1bbd6f2bd1559" => :mavericks
  end

  depends_on "ant" => :build
  depends_on :java

  # Uses symbols missing from El Capitan's IOBluetooth.framework
  # Reported upstream 1st May 2016 : https://github.com/ieee8023/blucat/issues/2
  depends_on MaximumMacOSRequirement => :yosemite

  def install
    system "ant"
    libexec.install "blucat"
    libexec.install "lib"
    libexec.install "build"
    bin.write_exec_script libexec/"blucat"
  end

  test do
    system "#{bin}/blucat", "doctor"
  end
end
