class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev"
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs.git",
      :tag      => "v0.0.5",
      :revision => "a9c43588e4cb038e6ac02f050e4cab81f8228dff"
  revision 2

  bottle do
    cellar :any
    sha256 "79f83436a823559dd871dbff7ec412e4ead6ce057f53eb053c2a15a71a3978ae" => :mojave
    sha256 "2a82aef85264e05dbfe247c84dad1793d922ce0c73241bb626a65c9f75b526fa" => :high_sierra
    sha256 "fd1316a3bad13cb134e374d14e745ab8f28995011897f260b5b9273dd1ac23c3" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "libev"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-applecc"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "simple-obfs", shell_output("#{bin}/obfs-local -h 2>&1")
  end
end
