class TtyClock < Formula
  desc "Analog clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v0.1.tar.gz"
  sha256 "866ee25c9ef467a5f79e9560c8f03f2c7a4c0371fb5833d5a311a3103e532691"
  head "https://github.com/xorg62/tty-clock.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d1ce565fddc9acd2126a0a074e3963b313b08cfb8af16fd38ceb8fe6779d6abc" => :sierra
    sha256 "460ccb1fb00cefca0ab73223dd0512ea13516c7771b45c32398a80e41f181842" => :el_capitan
    sha256 "2953c2761a2c69542eaf626b03d98ab8f088b7dacc0cb53e073ea71800327b99" => :yosemite
  end

  def install
    inreplace "Makefile", "/usr/local/bin/", "#{bin}/"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tty-clock", "-i"
  end
end
