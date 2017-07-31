class Burp < Formula
  desc "Network backup and restore"
  homepage "http://burp.grke.org/"

  stable do
    url "https://downloads.sourceforge.net/project/burp/burp-2.0.54/burp-2.0.54.tar.bz2"
    sha256 "ae10470586f1fee4556eaae5b3c52b78cfc0eac4109f4b8253c549e7ff000d86"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash/archive/v2.0.1.tar.gz"
      sha256 "613b95fcc368b7d015ad2d0802313277012f50c4ac290c3dfc142d42ebea3337"
    end
  end

  bottle do
    rebuild 1
    sha256 "e1f09e363ecb55cbc0ac2d60b017823b96af2973dd446ca58376dcc75279f8e3" => :sierra
    sha256 "4108e33cbce7408963a325201fa676dac06982ab821c7e322fc0d4b1476bc207" => :el_capitan
    sha256 "1724be8f1cb4f49bb20d9aacddba98df681805ad01eeff1a847a89936a6ff205" => :yosemite
  end

  devel do
    url "https://downloads.sourceforge.net/project/burp/burp-2.1.14/burp-2.1.14.tar.bz2"
    sha256 "c0e8d29e85390c03cd8d2770ab0e8e06c9c2713630a6eee6d0f52013f6533781"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          :revision => "7f1b50be94ceffcc7acd7a7f3f0f8f9aae52cc2f"
    end
  end

  head do
    url "https://github.com/grke/burp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git"
    end
  end

  depends_on "librsync"
  depends_on "openssl"

  def install
    resource("uthash").stage do
      system "make", "-C", "libut"
      (buildpath/"uthash/lib").install "libut/libut.a"
      (buildpath/"uthash/include").install Dir["src/*"]
    end

    ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"
    ENV.prepend "LDFLAGS", "-L#{buildpath}/uthash/lib"

    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"

    system "make", "install-all"
  end

  def post_install
    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats; <<-EOS.undent
    Before installing the launchd entry you should configure your burp client in
      #{etc}/burp/burp.conf
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>UserName</key>
      <string>root</string>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/burp</string>
        <string>-a</string>
        <string>t</string>
      </array>
      <key>StartInterval</key>
      <integer>1200</integer>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"burp", "-v"
  end
end
