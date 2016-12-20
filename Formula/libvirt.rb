class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-2.5.0.tar.xz"
  sha256 "819dffefbfd6ae95dfe1b28cfdee15ebcf9f91bbd732157488a57705bf81cb1e"

  head "https://github.com/libvirt/libvirt.git"

  bottle do
    rebuild 1
    sha256 "842296da6048ba3c041a6eaa1b2e19d8892eba263bf9ba976a8732e1dab3b2d1" => :sierra
    sha256 "435c2719a71f40ffab7d9a3f0bf21c6eca65e2c1e7c3225942c037b92d2ca49d" => :el_capitan
    sha256 "347e856c9587da414024f8d564a8125b5fa8aa1564ece2b336aa177bbbabc7af" => :yosemite
  end

  option "without-libvirtd", "Build only the virsh client and development libraries"

  depends_on "pkg-config" => :build
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

  if MacOS.version <= :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
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
      --with-yajl
      --without-qemu
    ]

    args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen" if build.head?
    args << "--without-libvirtd" if build.without? "libvirtd"

    system "./autogen.sh" if build.head?
    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf", "/etc/", "#{HOMEBREW_PREFIX}/etc/"

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    if build.with? "libvirtd"
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
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
