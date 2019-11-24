class Libsvg < Formula
  desc "Library for SVG files"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "407b958d5c796ac9efd9a54554e33ac1ca8c4975581bf943e726222ac8ebf0f9" => :catalina
    sha256 "ec0630881dc2cccd29048d39e1cd47be52d6eae02484e01f17a193097dce7c7d" => :mojave
    sha256 "4571607ab7c2d61afa2215c8ff374c41a2fb0df091745a3508e3678121e6beac" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  uses_from_macos "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
