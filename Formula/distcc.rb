class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/archive/v3.2rc1.tar.gz"
  sha256 "33e85981ff6afd94efc38b23b2d8b9036b3dff2dc6eac6982b9ff0ae1de64caa"
  head "https://github.com/distcc/distcc.git"

  bottle do
    rebuild 2
    sha256 "00af17479e527dce8f94b435343100e489edcd72d479ceec6acf661d3d79c1cc" => :high_sierra
    sha256 "57773f40ff2e40b476204195ef72e7bf9ab6059af85a5d4acf5fb707e4487de3" => :sierra
    sha256 "1139ea0e7cf997c2f9470a4ef54bd4f8d61e9ead750f5922ea02bd6ff919303d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Make sure python stuff is put into the Cellar.
    # --root triggers a bug and installs into HOMEBREW_PREFIX/lib/python2.7/site-packages instead of the Cellar.
    inreplace "Makefile.in", '--root="$$DESTDIR"', ""
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "distccd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/bin/distccd</string>
            <string>--daemon</string>
            <string>--no-detach</string>
            <string>--allow=192.168.0.1/24</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/distcc", "--version"
  end
end
