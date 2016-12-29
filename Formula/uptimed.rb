class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.0.tar.gz"
  sha256 "26891965bb499065e34072cecd3eb8087102b1c05f530c8fe8504a07c722f9bf"

  bottle do
    rebuild 1
    sha256 "34079362ef343cc3c49f0a67a19ae1ef8ee0fbe8b169b1a2f7f87dc4063b4762" => :sierra
    sha256 "f28f35a3c2b2b5d5146d28bdc697ccccdbb2be4bf17ae4e7b35e824ddfec78c8" => :el_capitan
    sha256 "1d84623d8cf1d9edc7abdf4d3cb400227561793e6930085a928fd6e99cd428df" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make", "install"
  end

  plist_options :manual => "uptimed"

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
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/uptimed</string>
          <string>-f</string>
          <string>-p</string>
          <string>#{var}/run/uptimed.pid</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/uptimed", "-t", "0"
    sleep 2
    output = shell_output("#{bin}/uprecords -s")
    assert_match /->\s+\d+\s+\d+\w,\s+\d+:\d+:\d+\s+|.*/, output, "Uptime returned is invalid"
  end
end
