class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.6.tar.gz"
  sha256 "8814828c6c245140a5c867d8def8e88a72e90f67c79282008303de1c1d598e4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a699ec4cdbab17257f0941533cbe155ff0e3b56d6acf960c9e4b2729e6d21840" => :catalina
    sha256 "1decc26df7fe1c99441c0e997e09f35c4f2b066e21d3517e3884bacb4bad84c9" => :mojave
    sha256 "5b635fd3d1e78df2d96457f130bd094186dbff5f17c5df933d06aeab97cfbf96" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  conflicts_with "renameutils", :because => "both install `icmd` binaries"

  def install
    # Darwin does not exist only on PowerPC
    inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
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
