class PostgresqlAT94 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.4.12/postgresql-9.4.12.tar.bz2"
  sha256 "fca055481875d1c49e31c28443f56472a1474b3fbe25b7ae64440c6118f82e64"

  bottle do
    rebuild 1
    sha256 "cb08cf0db9244763b2420cd514c323dab12e779267394de67f3d3cc97dee320c" => :sierra
    sha256 "90363f82c1791166de4976a705400c93f624abf3e1af72fb2b1f50b2943cca2d" => :el_capitan
    sha256 "798d184c48c4f489945ce37654f5fdbd23c7398a78fa897bc5d7e1ac1ed4fa53" => :yosemite
  end

  keg_only :versioned_formula

  option "without-perl", "Build without Perl support"
  option "without-tcl", "Build without Tcl support"
  option "with-dtrace", "Build with DTrace support"

  depends_on "openssl"
  depends_on "readline"
  depends_on :python => :optional

  fails_with :clang do
    build 211
    cause "Miscompilation resulting in segfault on queries"
  end

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include} -I#{Formula["readline"].opt_include}"
    ENV.append_to_cflags "-D_XOPEN_SOURCE"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{pkgshare}
      --docdir=#{doc}
      --enable-thread-safety
      --with-bonjour
      --with-gssapi
      --with-ldap
      --with-openssl
      --with-pam
      --with-libxml
      --with-libxslt
    ]

    args << "--with-perl" if build.with? "perl"
    args << "--with-python" if build.with? "python"

    # The CLT is required to build tcl support on 10.7 and 10.8 because tclConfig.sh is not part of the SDK
    if build.with?("tcl") && (MacOS.version >= :mavericks || MacOS::CLT.installed?)
      args << "--with-tcl"

      if File.exist?("#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/tclConfig.sh")
        args << "--with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
      end
    end

    args << "--enable-dtrace" if build.with? "dtrace"
    args << "--with-uuid=e2fs"

    system "./configure", *args
    system "make", "install-world"
  end

  def post_install
    (var/"log").mkpath
    (var/name).mkpath
    unless File.exist? "#{var}/#{name}/PG_VERSION"
      system "#{bin}/initdb", "#{var}/#{name}"
    end
  end

  def caveats
    s = <<-EOS.undent
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/legacy-homebrew/issues/2510

    To migrate existing data from a previous major version (pre-9.3) of PostgreSQL, see:
      https://www.postgresql.org/docs/9.3/static/upgrading.html
    EOS

    if MacOS.prefer_64_bit?
      s << <<-EOS.undent
      \nWhen installing the postgres gem, including ARCHFLAGS is recommended:
        ARCHFLAGS="-arch x86_64" gem install pg

      To install gems without sudo, see the Homebrew documentation:
      https://github.com/Homebrew/brew/blob/master/docs/Gems%2C-Eggs-and-Perl-Modules.md
      EOS
    end

    s
  end

  plist_options :manual => "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgresql@9.4 start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/postgres</string>
        <string>-D</string>
        <string>#{var}/#{name}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/#{name}.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test"
  end
end
