class Ganglia < Formula
  desc "Scalable distributed monitoring system"
  homepage "https://ganglia.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.7.2/ganglia-3.7.2.tar.gz"
  sha256 "042dbcaf580a661b55ae4d9f9b3566230b2232169a0898e91a797a4c61888409"
  revision 2

  bottle do
    rebuild 1
    sha256 "e9cc9c726e9f617b305bb32bc59c6c93d7601077edc7b1d2be3c8ee3da2a9188" => :high_sierra
    sha256 "99e4c79783f1398d0235a0f22e68ad45c812e89f9ac614db3f765d877dc98916" => :sierra
    sha256 "ad8b6bec6fbd9e72aa59be5714968435a99121b7a4e44ae1716d468c68d581bd" => :el_capitan
  end

  head do
    url "https://github.com/ganglia/monitor-core.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "confuse"
  depends_on "pcre"
  depends_on "rrdtool"

  conflicts_with "coreutils", :because => "both install `gstat` binaries"

  def install
    if build.head?
      inreplace "bootstrap", "libtoolize", "glibtoolize"
      inreplace "libmetrics/bootstrap", "libtoolize", "glibtoolize"
      system "./bootstrap"
    end

    inreplace "configure", 'varstatedir="/var/lib"', %Q(varstatedir="#{var}/lib")
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-gmetad",
                          "--with-libapr=#{Formula["apr"].opt_bin}/apr-1-config",
                          "--with-libpcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exist? "#{etc}/gmond.conf"
  end

  def post_install
    (var/"lib/ganglia/rrds").mkpath
  end

  def caveats; <<-EOS.undent
    If you didn't have a default config file, one was created here:
      #{etc}/gmond.conf
    EOS
  end

  test do
    begin
      pid = fork do
        exec bin/"gmetad", "--pid-file=#{testpath}/pid"
      end
      sleep 2
      assert_predicate testpath/"pid", :exist?
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
