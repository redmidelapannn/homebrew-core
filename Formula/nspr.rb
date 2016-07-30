class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.12/src/nspr-4.12.tar.gz"
  sha256 "e0b10a1e569153668ff8bdea6c7e491b389fab69c2f18285a1ebf7c2ea4269de"

  bottle do
    cellar :any
    revision 1
    sha256 "3e1b258a6ce1e0e324d30753099d14db2edaca90c7b9ac90216abf0a80854804" => :el_capitan
    sha256 "87e314cba1fb0408b42a66509999f4ccc1aef9d6d06916d8200c47e9d784fab6" => :yosemite
    sha256 "306446fde42e10a963f30ee0b6146d39b7034ec0c85d9156b116605e5d75fe88" => :mavericks
  end

  keg_only <<-EOS.undent
    Having this library symlinked makes Firefox pick it up instead of built-in,
    so it then randomly crashes without meaningful explanation.

    Please see https://bugzilla.mozilla.org/show_bug.cgi?id=1142646 for details.
  EOS

  def install
    ENV.deparallelize
    cd "nspr" do
      # Fixes a bug with linking against CoreFoundation, needed to work with SpiderMonkey
      # See: https://openradar.appspot.com/7209349
      target_frameworks = (Hardware::CPU.is_32_bit? || MacOS.version <= :leopard) ? "-framework Carbon" : ""
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
