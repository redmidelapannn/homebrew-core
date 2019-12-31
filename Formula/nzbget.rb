class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v21.0/nzbget-21.0-src.tar.gz"
  sha256 "65a5d58eb8f301e62cf086b72212cbf91de72316ffc19182ae45119ddd058d53"
  revision 1
  head "https://github.com/nzbget/nzbget.git", :branch => "develop"

  bottle do
    rebuild 1
    sha256 "f1f9e41567a2373e523e91db459d51300c0d120021b06c502f0791613ad6765d" => :catalina
    sha256 "bccfafa37bc8744230faed0ed0eef146273e5e1551568f0eea8fd232c1378560" => :mojave
    sha256 "f4603f54d26538d81ce784ae19380c5e5d57291965279d4abbb960839376ae1d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gcc" if MacOS.version == :mavericks
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    # Fix "ncurses library not found"
    # Reported 14 Aug 2016: https://github.com/nzbget/nzbget/issues/264
    (buildpath/"brew_include").install_symlink MacOS.sdk_path/"usr/include/ncurses.h"
    ENV["ncurses_CFLAGS"] = "-I#{buildpath}/brew_include"
    ENV["ncurses_LIBS"] = "-L/usr/lib -lncurses"

    # Tell configure to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.deparallelize
    system "make", "install"
    pkgshare.install_symlink "nzbget.conf" => "webui/nzbget.conf"

    # Set upstream's recommended values for file systems without
    # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
    inreplace "nzbget.conf", "DirectWrite=yes", "DirectWrite=no"
    inreplace "nzbget.conf", "ArticleCache=0", "ArticleCache=700"

    etc.install "nzbget.conf"
  end

  plist_options :manual => "nzbget"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>#{HOMEBREW_PREFIX}/bin:$PATH</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/nzbget</string>
        <string>-s</string>
        <string>-o</string>
        <string>OutputMode=Log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system "#{bin}/nzbget", "-D"
    # Query server for version information
    system "#{bin}/nzbget", "-V"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q"
  end
end
