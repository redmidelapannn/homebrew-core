class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-8.0.5.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-8.0.5.tar.bz2"
    sha256 "8ede46ef4b7961b0f53dc3418985f30569725c671ea9e6626dc8bbf0ca46544f"
  end

  bottle do
    rebuild 1
    sha256 "dd6e04a0cebe6928e208f8ff4f2eb723b7db0d276d05b758db4e4c2d27e059a7" => :catalina
    sha256 "6113e053b927783ccf6c7725f5657f9ab92efd04850b514f0a6343dc6015fca5" => :mojave
    sha256 "9a584d9da1dba2a745c596ee7e6442374aeb5a9a95d12e8da7b4677d02b5ed65" => :high_sierra
  end

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build

    fails_with :clang do
      build 800
      cause "needs C++17"
    end
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    ENV.cxx11 if build.stable?

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/trafficserver
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --with-group=admin
      --disable-silent-rules
      --enable-experimental-plugins
    ]

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
