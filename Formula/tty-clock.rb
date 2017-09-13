class TtyClock < Formula
  desc "Digital clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v2.3.tar.gz"
  sha256 "343e119858db7d5622a545e15a3bbfde65c107440700b62f9df0926db8f57984"
  head "https://github.com/xorg62/tty-clock.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6fa6541dde60647f72b37496e91479dc494251bff4ea1c987f8dd33f91ad2c05" => :sierra
    sha256 "b1c878b47d3c4035e752e188c9ccf84d5a6305fe09bcc8071ba19a18efed1bf5" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    ENV.append "LDFLAGS", "-lncurses"
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/tty-clock", "-i"
  end
end
