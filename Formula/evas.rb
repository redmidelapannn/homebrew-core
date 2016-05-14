class Evas < Formula
  desc "Display canvas API that implements a scene graph"
  homepage "https://docs.enlightenment.org/auto/eet/evas_main.html"
  url "https://download.enlightenment.org/releases/evas-1.7.10.tar.gz"
  sha256 "9c6c8679608ab0f2aa78e83f2ac1f9133d5bb615dabd5491bbbd30fcec4fc82b"

  bottle do
    revision 1
    sha256 "331486eea5729506c3409ac93a8baeea9a22949d7a59de6aa8e585729c3696b8" => :el_capitan
    sha256 "1362375aad073259ea98d5ca232a2b0e8c1a47f2662ab7bf32017ff0cae42b71" => :yosemite
    sha256 "e148eea7dc392da7df7bd615e01e9a1b42d64f4eec8c6fbbb991e0dd76123ebb" => :mavericks
  end

  conflicts_with "efl", :because => "efl aggregates formerly distinct libs, one of which is evas"

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "pkg-config" => :build
  depends_on "eina"
  depends_on "eet"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end
end
