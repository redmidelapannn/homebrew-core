# This now builds a version of JACKv1 which matches the current API
# for JACKv2. JACKv2 is not buildable on a number of macOS
# distributions, and the JACK team instead suggests installation of
# JACKOSX, a pre-built binary form for which the source is not available.
# If you require JACKv2, you should use that. Otherwise, this formula should
# operate fine.
# Please see https://github.com/Homebrew/homebrew/pull/22043 for more info
class Jack < Formula
  desc "Audio Connection Kit"
  homepage "http://jackaudio.org"
  url "http://jackaudio.org/downloads/jack-audio-connection-kit-0.125.0.tar.gz"
  sha256 "3517b5bff82139a76b2b66fe2fd9a3b34b6e594c184f95a988524c575b11d444"
  revision 3

  bottle do
    rebuild 2
    sha256 "6285c6799d590108ce3a44e24b11d49deab084146f0dab7615f993504c2e63ea" => :mojave
    sha256 "8be04eecbd0bce8b6b90c049a779920fa01c3fbb6c17f9ce4fe94942c6d702cf" => :high_sierra
    sha256 "8da51d9efe99e5894d14ae4063b180d626d960e1f811e15f44ca9f66c839fd6f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libsamplerate"
  depends_on "libsndfile"

  conflicts_with "jack2", :because => "both install `jackd` binaries and libraries"

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

    # Makefile hardcodes Carbon header location
    inreplace Dir["drivers/coreaudio/Makefile.{am,in}"],
      "/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h",
      "#{sdk}/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h"

    # https://github.com/jackaudio/jack1/issues/81
    inreplace "configure", "-mmacosx-version-min=10.4",
                           "-mmacosx-version-min=#{MacOS.version}"

    ENV["LINKFLAGS"] = ENV.ldflags
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "jackd -d coreaudio"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{opt_prefix}</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/jackd</string>
        <string>-d</string>
        <string>coreaudio</string>
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
    assert_match version.to_s, shell_output("#{bin}/jackd --version")
  end
end
