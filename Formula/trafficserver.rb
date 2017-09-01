class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-7.1.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-7.1.0.tar.bz2"
  sha256 "80b0bfd5f01f4e8b8ee0400a733c4d690cb249717b93c8bf8f982c98e5b91135"

  bottle do
    rebuild 1
    sha256 "083f5e5be35670b8ea65984eee7fe0054bf37d5cc871aecdc6b442794105d1dd" => :sierra
    sha256 "ce59d13b80593951c97c85216fd2c6f3c1356081fcb3540bb08621296549051c" => :el_capitan
    sha256 "906a6f28293fd51aa4218fa3bef1a8ac32e60584bbebaef493492509315ee951" => :yosemite
  end

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  option "with-experimental-plugins", "Enable experimental plugins"

  depends_on "openssl"
  depends_on "pcre"

  needs :cxx11

  def install
    ENV.cxx11

    # Needed for OpenSSL headers
    if MacOS.version <= :lion
      ENV.append_to_cflags "-Wno-deprecated-declarations"
    end

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/trafficserver
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-group=admin
      --disable-silent-rules
    ]

    args << "--enable-experimental-plugins" if build.with? "experimental-plugins"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args

    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", "$USER"

    inreplace "lib/perl/Makefile",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS)",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS) INSTALLSITEMAN3DIR=#{man3}"

    system "make" if build.head?
    system "make", "install"
  end

  def post_install
    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    config.append_lines "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
  end

  test do
    output = shell_output("#{bin}/trafficserver status")
    assert_match "Apache Traffic Server is not running", output
  end
end
