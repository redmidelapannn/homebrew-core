class Zssh < Formula
  desc "Interactive file transfers over SSH"
  homepage "https://zssh.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zssh/zssh/1.5/zssh-1.5c.tgz"
  sha256 "a2e840f82590690d27ea1ea1141af509ee34681fede897e58ae8d354701ce71b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e8ca598482952e2a0f46d670ebd0906b965c0b04f38d9e8e71e94d2deeae5a3" => :high_sierra
    sha256 "087c9caf12739204500611f875ac594dd207575495a6fa70fca7d3dd642233b0" => :sierra
    sha256 "7b7031051642f4d4646fa9d15a65d67ac61a75ffa35b3517a5e98f729ff354ae" => :el_capitan
  end

  depends_on "lrzsz"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "zssh", "ztelnet"
    man1.install "zssh.1", "ztelnet.1"
  end

  test do
    system "#{bin}/zssh", "--version"
  end
end
