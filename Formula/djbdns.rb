class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  bottle do
    rebuild 4
    sha256 "3451b9f10b5d98df900fbffd8c0c83501bc41effc3038420afcbb1eada851d28" => :mojave
    sha256 "0153405f93843d3bd3f698724c68825c654b3df4ba881c87341860eca9f0f2bc" => :high_sierra
    sha256 "abeabf730d9a0c155f3b6fe7cca3fdfbbf9b99bd1dfce1f6482740dd601c7311" => :sierra
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

    if MacOS.sdk_path_if_needed
      (buildpath/"conf-cc").write "gcc -O2 -include #{MacOS.sdk_path}/usr/include/errno.h"
    else
      (buildpath/"conf-cc").write "gcc -O2 -include /usr/include/errno.h"
    end

    bin.mkpath
    (prefix/"etc").mkpath # Otherwise "file does not exist"
    system "make", "setup", "check"
  end

  test do
    # Use example.com instead of localhost, because localhost does not resolve in all cases
    assert_match /\d+\.\d+\.\d+\.\d+/, shell_output("#{bin}/dnsip example.com").chomp
  end
end
