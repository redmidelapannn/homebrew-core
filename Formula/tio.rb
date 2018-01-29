class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.29/tio-1.29.tar.xz"
  sha256 "371a11b69dd2e1b1af3ca2a1c570408b1452ae4523fe954d250f04b6b2147d23"

  bottle do
    cellar :any_skip_relocation
    sha256 "470096bda7f34e4baf3f06f403a879c94dbc9224783e00043c4ad13b94994ee3" => :high_sierra
    sha256 "ef00daf00caf2229f4ccd3b0c06d6a79985333587bee369fb2bb1dbe69651fb2" => :sierra
    sha256 "806178acaf797f2821b279be71065a3fdc20be91cea3ba47b551a670e65a3b17" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/tio -h", 0)
  end
end
