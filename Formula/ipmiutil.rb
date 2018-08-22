class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-2.9.5.tar.gz"
  sha256 "eb00f0582ee75e1f8d371e398d546ddd7639595b9a0a1f27a84cc6ecb038dbe6"

  bottle do
    cellar :any
    sha256 "5ccb298e95d2a6f8303bc8c5d3a6b4631022f9fab3497c758c852f014301dbf1" => :mojave
    sha256 "50cce938979cf77f307cb2e17e08fe6a1402b1f785561a578360d75308138288" => :high_sierra
    sha256 "896eea4929dcd86ede955f0657424d1bb40e9a08e1aeb4d42658f4a8c00a9095" => :sierra
    sha256 "25f46961b538e12edffb311b07cd90af6ad7e4dc323431b6e512375f243e9f21" => :el_capitan
    sha256 "9fe09553dea21a6ea088bf0d571400da32b9826ab07263e6f9f618c34c2980b4" => :yosemite
    sha256 "b1372295d77f7d211372bb496c856778369397fea35db58aba7262ad157e191e" => :mavericks
    sha256 "debbe1e403702b0ee6178ca9674f7c05c4db8f1e68256152eb1c91482eaeda2d" => :mountain_lion
  end

  depends_on "openssl"

  # Ensure ipmiutil does not try to link against (disabled) OpenSSL's MD2
  # support. Patch submitted upstream in
  # https://sourceforge.net/p/ipmiutil/mailman/message/33373858/
  patch :DATA

  conflicts_with "renameutils", :because => "both install `icmd` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
  end
end

__END__
diff -u ./configure.bak ./configure
--- ./configure.bak       2015-02-04 22:15:07.000000000 +0100
+++ ./configure   2015-02-04 22:16:18.000000000 +0100
@@ -20739,7 +20739,7 @@
            echo "Detected HP-UX"
            os=hpux
            MD2_CFLAGS="-DSKIP_MD2"
-           OS_CFLAGS="-DHPUX"
+           OS_CFLAGS="-DHPUX $MD2_CFLAGS"
            OS_LFLAGS=""
            OS_DRIVERS="ipmimv.c"
            drivers="open"
@@ -20748,7 +20748,7 @@
            echo "Detected MacOSX"
            os=macos
            MD2_CFLAGS="-DSKIP_MD2"
-           OS_CFLAGS="-DMACOS"
+           OS_CFLAGS="-DMACOS $MD2_CFLAGS"
            OS_LFLAGS=""
           OS_DRIVERS="ipmimv.c ipmidir.c"
           drivers="open direct"
