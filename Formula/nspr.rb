class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.14/src/nspr-4.14.tar.gz"
  sha256 "64fc18826257403a9132240aa3c45193d577a84b08e96f7e7770a97c074d17d5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eff6e63f464f43a907f7b3306c200eeb1634f609018b2da06342e13cf652625a" => :sierra
    sha256 "e5185f4a87d9fe07979696d4355983456168f72971376276e95351fb0ae45372" => :el_capitan
    sha256 "f103d55b21dbe4c953c3601634f7345f5079e96be222338f5b1012eee5459ad9" => :yosemite
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      target_frameworks = Hardware::CPU.is_32_bit? ? "-framework Carbon" : ""
      inreplace "pr/src/Makefile.in", "-framework CoreServices -framework CoreFoundation", target_frameworks

      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
      ]
      args << "--enable-64bit" if MacOS.prefer_64_bit?
      system "./configure", *args
      # Remove the broken (for anyone but Firefox) install_name
      inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end
end
