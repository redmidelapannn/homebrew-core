class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "http://autotrace.sourceforge.net"
  url "https://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz"
  sha256 "5a1a923c3335dfd7cbcccb2bbd4cc3d68cafe7713686a2f46a1591ed8a92aff6"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "264a63425636171f731273aee138269684b8bc5c4b9dbec80e077ffce4ef93ef" => :el_capitan
    sha256 "0231af2e11ae4f5b629b3b5d40ec22cfa3c2e0f52e1b81ef9a1321da664790f4" => :yosemite
    sha256 "47accc06a0df0e43eda31a65800ff3f8cffdd924948705da9525fb479ffa2b44" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick" => :recommended

  # Issue 16569: Use MacPorts patch to port input-png.c to libpng 1.5.
  # Fix underquoted m4
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5b41470/autotrace/patch-libpng-1.5.diff"
    sha256 "9c57a03d907db94956324e9199c7b5431701c51919af6dfcff4793421a1f31fe"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5b41470/autotrace/patch-autotrace.m4.diff"
    sha256 "12d794c99938994f5798779ab268a88aff56af8ab4d509e14383a245ae713720"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--without-magick" if build.without? "imagemagick"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autotrace -version")

    # Prepare a bitmap `autotrace` can work with (there's something to trace).
    convert = Formula["imagemagick"].bin/"convert"
    system convert, test_fixtures("test.eps"), "test.tga"

    system bin/"autotrace", "-output-file", "test.eps", "test.tga"
    assert_predicate testpath/"test.eps", :exist?
  end
end
