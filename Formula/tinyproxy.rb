class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://www.banu.com/tinyproxy/"
  url "https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2"
  sha256 "be559b54eb4772a703ad35239d1cb59d32f7cf8a739966742622d57df88b896e"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "6096f1a5f1ae412ec1775ec93ed4749ecdc275d661a1efc8bdd6d1b3427af264" => :sierra
    sha256 "1ae89c76d1294879048c461e7e82f1090f5ddcd292e61f4e0cfa7f41f0a71d1e" => :el_capitan
    sha256 "78d9ab116e8bb4b35eeb9f06e83bd61235cab975ad012101381fd0faccc2b1f1" => :yosemite
  end

  depends_on "asciidoc" => :build

  option "with-reverse", "Enable reverse proxying"
  option "with-transparent", "Enable transparent proxying"
  option "with-filter", "Enable url filtering"

  deprecated_option "reverse" => "with-reverse"

  # Fix linking error, via MacPorts: https://trac.macports.org/ticket/27762
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2b17ed2/tinyproxy/patch-configure.diff"
    sha256 "414b8ae7d0944fb8d90bef708864c4634ce1576c5f89dd79539bce1f630c9c8d"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
    ]

    args << "--enable-reverse" if build.with? "reverse"
    args << "--enable-transparent" if build.with? "transparent"
    args << "--enable-filter" if build.with? "filter"

    system "./configure", *args

    # Fix broken XML lint
    # See: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=154624
    inreplace %w[docs/man5/Makefile docs/man8/Makefile], "-f manpage",
                                                         "-f manpage \\\n  -L"

    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  test do
    pid = fork do
      exec "#{sbin}/tinyproxy"
    end
    sleep 2

    begin
      assert_match /tinyproxy/, shell_output("curl localhost:8888")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end

  plist_options :manual => "tinyproxy"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/tinyproxy</string>
            <string>-d</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
