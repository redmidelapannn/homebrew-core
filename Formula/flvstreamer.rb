class Flvstreamer < Formula
  desc "Stream audio and video from flash & RTMP Servers"
  homepage "https://www.nongnu.org/flvstreamer/"
  url "https://download.savannah.gnu.org/releases/flvstreamer/source/flvstreamer-2.1c1.tar.gz"
  sha256 "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "daf93876249079a7b8e65df8a75ae3aed586dcfbf595f2e007617040e1ab7386" => :high_sierra
    sha256 "e7879522ec357f50b9658ec4f1796022195e6c70e12bcf7e4c132d7d17770c51" => :sierra
    sha256 "636dd0fba8c4f2a0528714e08eda2dd53f4a63f0ec01c4604907f8ed809f4b40" => :el_capitan
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
