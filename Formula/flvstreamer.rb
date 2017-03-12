class Flvstreamer < Formula
  desc "Stream audio and video from flash & RTMP Servers"
  homepage "http://www.nongnu.org/flvstreamer/"
  url "https://download.savannah.gnu.org/releases/flvstreamer/source/flvstreamer-2.1c1.tar.gz"
  sha256 "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "304e23b74ef53973da47de35b4314ba8232a97d9578c06b49410d1b8268ed934" => :sierra
    sha256 "96ebcb8f07f7e64348d2a7bf1c74474c63b5602d76fbdc47229fd22e9d8f627b" => :el_capitan
    sha256 "5d42cc9cbfbbc33413b77db81ef39decbe39d618f0cc106b118f883b8f9ad359" => :yosemite
  end

  conflicts_with "rtmpdump", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  def install
    system "make", "posix"
    bin.install "flvstreamer", "rtmpsrv", "rtmpsuck", "streams"
  end

  test do
    system "#{bin}/flvstreamer", "-h"
  end
end
