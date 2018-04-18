class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/2.6.1/shibboleth-sp-2.6.1.tar.bz2"
  sha256 "1121e3b726b844d829ad86f2047be62da4284ce965ac184de2f81903f16b98e4"

  bottle do
    rebuild 1
    sha256 "cc630cac9c67c67fdccc7079f981ca63657a29e6b863e488b1310913777fbc83" => :high_sierra
    sha256 "ad0f1550f3383af7988fc66c5b3e96c2ecdd25bd6f93a7e633979501e40cc1d8" => :sierra
    sha256 "5c5454804cf1c391a48682adfc92c4813506dc6a35d1837eaf6eaa88dfaef88c" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "curl" => "with-openssl"
  depends_on "httpd" if MacOS.version >= :high_sierra
  depends_on "opensaml"
  depends_on "xml-tooling-c"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "log4shib"
  depends_on "boost"
  depends_on "unixodbc"

  depends_on "apr-util" => :build
  depends_on "apr" => :build

  needs :cxx11

  def install
    ENV.O2 # Os breaks the build
    ENV.cxx11
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      --enable-apache-24
      DYLD_LIBRARY_PATH=#{lib}
    ]

    if MacOS.version >= :high_sierra
      args << "--with-apxs24=#{Formula["httpd"].opt_bin}/apxs"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    mod = build.with?("apache-22") ? "mod_shib_22.so" : "mod_shib_24.so"
    <<~EOS
      You must manually edit httpd.conf to include
      LoadModule mod_shib #{opt_lib}/shibboleth/#{mod}
      You must also manually configure
        #{etc}/shibboleth/shibboleth2.xml
      as per your own requirements. For more information please see
        https://wiki.shibboleth.net/confluence/display/EDS10/3.1+Configuring+the+Service+Provider
    EOS
  end

  plist_options :startup => true, :manual => "shibd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/shibd</string>
        <string>-F</string>
        <string>-f</string>
        <string>-p</string>
        <string>#{var}/run/shibboleth/shibd.pid</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  test do
    system sbin/"shibd", "-t"
  end
end
