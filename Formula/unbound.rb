class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://www.unbound.net/downloads/unbound-1.6.0.tar.gz"
  sha256 "6b7db874e6debda742fee8869d722e5a17faf1086e93c911b8564532aeeffab7"
  revision 1

  bottle do
    rebuild 1
    sha256 "d16578a04afd25cd6a52c67846459597f469e1a7ac95740210a65e5fd38baef9" => :sierra
    sha256 "19726f6dfdc57fafa0dcad7d28ce99db5c4442bf843ee3fcfc8bb6fa55f101bc" => :el_capitan
    sha256 "9a81647f595a539c69566c539529a5552f32a98b8a2173f6d331023cbfbf0f52" => :yosemite
  end

  depends_on "openssl"
  depends_on "libevent"

  depends_on :python => :optional
  depends_on "swig" if build.with?("python")

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "python"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp

      args << "--with-pyunbound"
      args << "--with-pythonmodule"
      args << "PYTHON_SITE_PKG=#{lib}/python2.7/site-packages"
    end

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?
    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "test"
    system "make", "install"
  end

  def post_install
    if File.read(etc/"unbound/unbound.conf").include?('username: "@@HOMEBREW-UNBOUND-USER@@"')
      inreplace etc/"unbound/unbound.conf", 'username: "@@HOMEBREW-UNBOUND-USER@@"', "username: \"#{ENV["USER"]}\""
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
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
