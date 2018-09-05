class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  revision 1

  bottle do
    rebuild 1
    sha256 "4248e97b8b4d2b3bbe228d15ed7a19a2e9f7989d6732b2a5722528242469d070" => :mojave
    sha256 "e1cb081129575fdb531dbe64121906afffed2931e281a0c98662cbada934a22b" => :sierra
    sha256 "a8ab5aea8fac29dfe51971920b57e465720fb9e21116decd5de3765f1d5b3cc4" => :el_capitan
  end

  keg_only :provided_by_macos, "Apple's CLT package contains apr"

  depends_on "apr"
  depends_on "openssl"

  def install
    # Install in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]
    rm Dir[libexec/"lib/apr-util-1/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end
