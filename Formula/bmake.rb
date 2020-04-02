class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200330.tar.gz"
  sha256 "d7257cbc50b1aa681088c831ab24379e268f3336a8da4af76fc320af24e75099"

  bottle do
    sha256 "3dbba6570c1f13c4774ff22ab455c9a555d67a83d0462e8b5e0fe31c27429fba" => :catalina
    sha256 "1b8c213e7f345379e046222163613cea8e22603c9c6e263b25daf11ca04cbedb" => :mojave
    sha256 "f8dc50a8ca3694dd6fd49e59da9015b8ae2e8be064b07eb7bf532a05ade6fb50" => :high_sierra
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
