class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20160908.4a07ab0.tar.gz"
  version "20160908"
  sha256 "7414ba38041c283db3b2c7bc119eecfcb193629c50f8509bd4693142813cea5d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "08a7c7c29f15eacaf226d2009dbec8e669e8c0d8eef69685d1373b02e611c301" => :sierra
    sha256 "eb351a5f05f1699c353cc304e8f59f30ef1e9b1eecc5a0a330a9b4c631e2ef5e" => :el_capitan
    sha256 "88c2de68183c4e575d667d4983bd0f0a1c3ac00756a6bbf12c2b4e14f7fb5591" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
