class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.0.1/qpdf-10.0.1.tar.gz"
  sha256 "5d2277c738188b7f4e3f01a6db7f2937ed6df54671f1fba834cd3d7ff865827b"

  bottle do
    cellar :any
    sha256 "95d4deda22ed179accadac1c813e7fc48fa10669821457f0fc62e06bcfb9da8e" => :catalina
    sha256 "b950cb0396a81a5e87d685c627e394e68a1598599cfc4de3fe232fa3ea41dea1" => :mojave
    sha256 "5799531c33d5f2fde596582a02abca25195d2bf1dedfd1442eafefe33019a60d" => :high_sierra
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
