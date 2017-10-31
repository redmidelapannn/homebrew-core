class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v19.1/nzbget-19.1-src.tar.gz"
  sha256 "06df42356ac2d63bbc9f7861abe9c3216df56fa06802e09e8a50b05f4ad95ce6"
  head "https://github.com/nzbget/nzbget.git", :branch => "develop"

  bottle do
    rebuild 1
    sha256 "08e0c5e739f2d3cb2e451f29c15702d82bf9e4f2cd46346da7936bce35f6f7b7" => :high_sierra
    sha256 "5619fe1214dd1caeacbb82393eb12d6e80c3746991d1c01ab14f9584ee68d2ef" => :sierra
    sha256 "e8d77300248137b6ee06dec919b0b91631b4574d014b396ad9affa5abaf8643f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gcc" if MacOS.version <= :mavericks

  needs :cxx11

  fails_with :clang do
    build 600
    cause "No compiler with C++14 support was found"
  end

  fails_with :clang do
    build 500
    cause <<~EOS
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
    EOS
  end

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
