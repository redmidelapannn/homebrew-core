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
    sha256 "14fd0784192b67450f5df9292bf3c0de09cf124989f7ce250f9083c3d2fbb622" => :sierra
    sha256 "781fe317e53596db8a918b5732b70a0773c1726f7345c6a7df62b9e7cbb8dad4" => :el_capitan
    sha256 "e9246e0de2d7b378b45665f629751ebad6ccdc0da88f3ed000d6677de69bb0db" => :yosemite
  end

  devel do
    url "https://downloads.sourceforge.net/project/burp/burp-2.1.16/burp-2.1.16.tar.bz2"
    sha256 "eb90a10ef2f17a57e9452b6d077ed40da263e671aeb7a9b5bb461b4dafbe7372"

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
