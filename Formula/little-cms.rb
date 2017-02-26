class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3adee1525631365a166152aa760c8944e239439fc4d5ba47f66e61f55d5a8ce7" => :sierra
    sha256 "79725cf92ab951f41b1b76a1394e4814d04c96ed64079c70277e4e1e4c546430" => :el_capitan
    sha256 "fae6cc12c20e5dc3f9461d7dbfe6d87078a8929e72c6f47f49c9360f06fb3b84" => :yosemite
  end

  depends_on :python => :optional
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    args = %W[--disable-dependency-tracking --disable-debug --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"
    if build.with? "python"
      args << "--with-python"
      inreplace "python/Makefile.in" do |s|
        s.change_make_var! "pkgdir", lib/"python2.7/site-packages"
      end
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/jpegicc", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist?("out.jpg")
  end
end
