class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/Mac%20OS%20X/Bit-Twist%202.0/bittwist-macosx-2.0.tar.gz"
  sha256 "8954462ac9e21376d9d24538018d1225ef19ddcddf9d27e0e37fe7597e408eaa"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "24ba338d30ca6b7646cccd18746204988d256158aa707a42eba62b18511e3a4a" => :sierra
    sha256 "a811238ac5043580e6696ca66700d2b59ca31a530228db8baef81fd4e10c0d85" => :el_capitan
    sha256 "16ed3ea43ff66359f5c341beaa0013b7a83f80c285651b84cb568334388ae38d" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
