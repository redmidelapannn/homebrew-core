class Xpdf < Formula
  desc "PDF viewer"
  homepage "http://www.foolabs.com/xpdf/"
  url "https://src.fedoraproject.org/repo/pkgs/xpdf/xpdf-3.04.tar.gz/3bc86c69c8ff444db52461270bef3f44/xpdf-3.04.tar.gz"
  mirror "https://fossies.org/linux/misc/legacy/xpdf-3.04.tar.gz"
  sha256 "11390c74733abcb262aaca4db68710f13ffffd42bfe2a0861a5dfc912b2977e5"
  revision 1

  bottle do
    rebuild 1
    sha256 "6ec9ed21503d317125752ac75ca45abe2d8cfeb2155785c0994ae51259d87eff" => :sierra
    sha256 "0310eb5ea4ad944ecb151f4a40fa4f5887d16a8befff14437a40f654e45f91b7" => :el_capitan
    sha256 "e0db810a597f5d35a5d26741a7beafb9d8263eddac44bc3c9532281a55514c8a" => :yosemite
  end

  depends_on "openmotif"
  depends_on "freetype"
  depends_on :x11

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    freetype = Formula["freetype"]
    openmotif = Formula["openmotif"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype2-library=#{freetype.opt_lib}",
                          "--with-freetype2-includes=#{freetype.opt_include}/freetype2",
                          "--with-Xm-library=#{openmotif.opt_lib}",
                          "--with-Xm-includes=#{openmotif.opt_include}",
                          "--with-Xpm-library=#{MacOS::X11.lib}",
                          "--with-Xpm-includes=#{MacOS::X11.include}",
                          "--with-Xext-library=#{MacOS::X11.lib}",
                          "--with-Xext-includes=#{MacOS::X11.include}",
                          "--with-Xp-library=#{MacOS::X11.lib}",
                          "--with-Xp-includes=#{MacOS::X11.include}",
                          "--with-Xt-library=#{MacOS::X11.lib}",
                          "--with-Xt-includes=#{MacOS::X11.include}"
    system "make"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
