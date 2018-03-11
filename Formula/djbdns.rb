class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  bottle do
    rebuild 2
    sha256 "2bbb1999a6b7d912223ec42f57c3a58ab0b9dab042065d12e8d877db706846f5" => :high_sierra
    sha256 "d97420d25710b7edaccf4fab8bcebbedc3718eb0135cee4eb78773dc75d7aa22" => :sierra
    sha256 "0a620c381e81134980b41b3cd438b534134f636ba80f944decb80233766b9a03" => :el_capitan
  end

  depends_on "daemontools"
  depends_on "ucspi-tcp"

  def install
    inreplace "hier.c", 'c("/"', "c(auto_home"
    inreplace "dnscache-conf.c", "/etc/dnsroots", "#{etc}/dnsroots"

    # Write these variables ourselves.
    rm %w[conf-home conf-ld conf-cc]
    (buildpath/"conf-home").write prefix
    (buildpath/"conf-ld").write "gcc"

    if MacOS::CLT.installed?
      (buildpath/"conf-cc").write "gcc -O2 -include /usr/include/errno.h"
    else
      (buildpath/"conf-cc").write "gcc -O2 -include #{MacOS.sdk_path}/usr/include/errno.h"
    end

    bin.mkpath
    (prefix/"etc").mkpath # Otherwise "file does not exist"
    system "make", "setup", "check"
  end

  test do
    assert_match /localhost/, shell_output("#{bin}/dnsname 127.0.0.1")
  end
end
