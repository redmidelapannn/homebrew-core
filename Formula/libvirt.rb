class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.0.0.tar.xz"
  sha256 "e6bb642389bbace3252c462bbb2e9b1749dd64315b9873a424f36c7f8d357f76"
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    sha256 "6e509dd62c2f5b483b382e42551abc5e07e17615cabaa9818b45a4ebab316473" => :catalina
    sha256 "2a360ce73e763512d89482b6a5a4661d042a2045a140f160f5fb94245438e332" => :mojave
    sha256 "da6ea126971e7a2de4bca5bf7097751198b172af13dc9dc4b56be066833e5ffa" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "docutils"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "rpcgen" => :build
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-esx
      --with-init-script=none
      --with-remote
      --with-test
      --with-vbox
      --with-vmware
      --with-qemu
    ]

    args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen" if build.head?

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    system "./autogen.sh" if build.head?
    mkdir "build" do
      system "../configure", *args

      # Compilation of docs doesn't get done if we jump straight to "make install"
      system "make"
      system "make", "install"
    end

    # Update the libvirt daemon config file to reflect the Homebrew prefix
    inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
      s.gsub! "/etc/", "#{etc}/"
      s.gsub! "/var/", "#{var}/"
    end
  end

  plist_options :manual => "libvirtd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/libvirtd</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
