class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://www.unbound.net/downloads/unbound-1.8.0.tar.gz"
  sha256 "78f79d6d3b643fdcd74a14fc76542250da886c82f82bc55b51e189663d61b83f"
  head "https://nlnetlabs.nl/svn/unbound/trunk/", :using => :svn

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    sha256 "91c9433b511c3adb51e28494fda633dbac9f68e90fcc668139ecd14a8427a458" => :mojave
    sha256 "779797785e9cf4d1e3c0aff23c05ada1e153313e9a1288ab07f8a4c347f929ec" => :high_sierra
    sha256 "fb5d7bdaa815cfd59f0ab056aa92fd74d5c037749092b46cfef55e907f1e302e" => :sierra
    sha256 "053ca8187353cc5699154e0a699f133dc5e706604826c4e9a1f9f3f951b6a992" => :el_capitan
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "openssl@1.1"
  depends_on "libevent"
  depends_on "python@2" => :optional
  depends_on "swig" if build.with? "python@2"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    if build.with? "python@2"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp
      ENV.prepend "PYTHON_VERSION", "2.7"

      args << "--with-pyunbound"
      args << "--with-pythonmodule"
      args << "PYTHON_SITE_PKG=#{lib}/python2.7/site-packages"
    end

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "test"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')
    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/unbound</string>
          <string>-d</string>
          <string>-c</string>
          <string>#{etc}/unbound/unbound.conf</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
