class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev."
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs/archive/v0.0.3.tar.gz"
  sha256 "350c22e138202868d5726cb55e3d71e9962aad3306988a9f746b80d0e8998a75"

  bottle do
    cellar :any
    sha256 "63365d9c829f170755ab88a9fc2d6adf6592b5b5e0ff6077c01bec0b4e5037b4" => :sierra
    sha256 "a54c0085f12901724ae08737ea82428688cbefa42eea85e34ca2dba4a491badb" => :el_capitan
    sha256 "4b59efc76f515909a17e20cc1b95123b87e376771e8a09584b9c68ccbc597cdd" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "udns"
  depends_on "libev"
  depends_on "libsodium"
  depends_on "pcre"
  depends_on "openssl"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "git", "clone", "https://github.com/shadowsocks/libcork.git", "libcork/"
    Dir.chdir("libcork")
    system "git", "checkout", "3bcb8324431d3bd4be5e4ff2a4323b455c8d5409"
    Dir.chdir("..")
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "simple-obfs", shell_output("#{bin}/obfs-local -h 2>&1")
  end
end
