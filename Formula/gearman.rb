class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.17/gearmand-1.1.17.tar.gz"
  sha256 "f9fa59d60c0ad03b449942c6fe24abe09456056852fae89a05052fa25c113c0f"

  bottle do
    rebuild 1
    sha256 "cdef3cbbc2127b3d94e3856097f4414f8c9727c88cecb7916d5e9a46ab84cbac" => :high_sierra
    sha256 "5877ad85cdf8a5e0a8842bf50de092495a9be5d20f738d3ec3edc7c0c51dae22" => :sierra
    sha256 "8ca48fdb459ceed5ed1e12cf6e0106d4d29f3b62701199e5028ee7071f63ded4" => :el_capitan
  end

  option "with-mysql", "Compile with MySQL persistent queue enabled"
  option "with-postgresql", "Compile with Postgresql persistent queue enabled"

  # https://github.com/Homebrew/homebrew/issues/33246
  patch :DATA

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libpqxx" if build.with? "postgresql"
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional
  depends_on "openssl" => :optional
  depends_on "wolfssl" => :optional
  depends_on "tokyo-cabinet" => :optional

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/ =~ File.read(test_file)
      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = [
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-libdrizzle",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-sqlite3",
    ]

    if build.with? "cyassl"
      args << "--enable-ssl" << "--enable-cyassl"
    elsif build.with? "openssl"
      args << "--enable-ssl" << "--with-openssl=#{Formula["openssl"].opt_prefix}" << "--disable-cyassl"
    else
      args << "--disable-ssl" << "--disable-cyassl"
    end

    if build.with? "postgresql"
      args << "--enable-libpq" << "--with-postgresql=#{Formula["postgresql"].opt_bin}/pg_config"
    else
      args << "--disable-libpq" << "--without-postgresql"
    end

    if build.with? "libmemcached"
      args << "--enable-libmemcached" << "--with-memcached=#{Formula["memcached"].opt_bin}/memcached"
    else
      args << "--disable-libmemcached" << "--without-memcached"
    end

    args << "--disable-libtokyocabinet" if build.without? "tokyo-cabinet"

    args << (build.with?("mysql") ? "--with-mysql=#{Formula["mysql"].opt_bin}/mysql_config" : "--without-mysql")
    args << (build.with?("hiredis") ? "--enable-hiredis" : "--disable-hiredis")

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "gearmand -d"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match /gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1)
  end
end

__END__
diff --git a/libgearman/byteorder.cc b/libgearman/byteorder.cc
index 674fed9..b2e2182 100644
--- a/libgearman/byteorder.cc
+++ b/libgearman/byteorder.cc
@@ -65,6 +65,8 @@ static inline uint64_t swap64(uint64_t in)
 }
 #endif
 
+#ifndef HAVE_HTONLL
+
 uint64_t ntohll(uint64_t value)
 {
   return swap64(value);
@@ -74,3 +76,5 @@ uint64_t htonll(uint64_t value)
 {
   return swap64(value);
 }
+
+#endif
