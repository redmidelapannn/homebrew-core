class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://developer.mozilla.org/docs/Mozilla/Projects/NSPR"
  url "https://archive.mozilla.org/pub/mozilla.org/nspr/releases/v4.19/src/nspr-4.19.tar.gz"
  sha256 "2ed95917fa2277910d1d1cf36030607dccc0ba522bba08e2af13c113dcd8f729"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c2e8153dc1407c9f99849d9627f71eed23aefe7f96dd1a307b635e5e05744476" => :high_sierra
    sha256 "a71f4eab4ddd3f6f8c0a099cb1ddaf283d87b6f25164251330f8527d9e00768d" => :sierra
    sha256 "b8f94028908018040ac98c2ca1d6e8b8077e006a82b689867dfd1af3784dc0e8" => :el_capitan
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

  test do
    system "#{bin}/nspr-config", "--version"
  end
end
