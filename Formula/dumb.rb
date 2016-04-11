class Dumb < Formula
  desc "IT, XM, S3M and MOD player library"
  homepage "http://dumb.sourceforge.net/index.php?page=about"
  url "https://downloads.sourceforge.net/project/dumb/dumb/0.9.3/dumb-0.9.3.tar.gz"
  sha256 "8d44fbc9e57f3bac9f761c3b12ce102d47d717f0dd846657fb988e0bb5d1ea33"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5afd070fb3927f876b4b92c64bc96156177fb75eaafb8995b8e9657b5b811a0" => :el_capitan
    sha256 "1949f3297311c7d0ca904b9b8290c95d02e0984e6e988cf7303a09c9e550a287" => :yosemite
    sha256 "dd4c3c1241f06451cfd815a07d8fae3285e474695e94b8bb2e6364ca111300e5" => :mavericks
  end

  def install
    (buildpath/"make/config.txt").write <<-EOS.undent
include make/unix.inc
ALL_TARGETS := core core-examples core-headers
PREFIX := #{prefix}
    EOS
    system "make"
    mkdir_p [bin, include, lib]
    system "make", "install"
  end
end
