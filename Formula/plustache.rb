class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/0.4.0.tar.gz"
  sha256 "83960c412a7c176664c48ba4d718e72b5d39935b24dc13d7b0f0840b98b06824"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0e04b8e5cf259e3657a65b033bd1735df4dde00e8372a6c442b5fb3e4dc86202" => :high_sierra
    sha256 "716c68f6db28135ea361387658e3a3f339f614343165baae5d3a5d4d5deb0e24" => :sierra
    sha256 "37e612368af36460d7b33363abc46f755b5d8f753013efc6b216cb8ac06fbb72" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
