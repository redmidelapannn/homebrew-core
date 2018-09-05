class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.16/dar-2.5.16.tar.gz"
  sha256 "e957c97101a17dc91dca00078457f225d2fa375d0db0ead7a64035378d4fc33b"

  bottle do
    rebuild 1
    sha256 "8d267c188eed7df39466212dcfdd850845d0baa17782fef9c07dd2dcbead53ce" => :mojave
    sha256 "492d86c20aaa281380d222d74703ff19404b95e9f786782ef18fb4b44affa373" => :sierra
    sha256 "cf9932017786500c3270a78bae3e7793d4a565b72e4b53a6694edde75265b508" => :el_capitan
  end

  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-libgcrypt-linking",
                          "--disable-liblzo2-linking",
                          "--disable-libxz-linking",
                          "--disable-upx",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
