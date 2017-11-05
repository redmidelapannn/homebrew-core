class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://github.com/andreabolognani/cattle"
  url "https://kiyuko.org/software/cattle/releases/1.2.2/source"
  sha256 "e8e9baba41c4b25a1fdac552c5b03ad62a4dbb782e9866df3c3463baf6411826"

  bottle do
    rebuild 1
    sha256 "45d82601ff83592e624679e963b279d04f8496d7bff5458be4a6a31002c393f9" => :high_sierra
    sha256 "d558bed929d69a4bb6046fb4d1618369a4a690d0bcf27ffeed3880f60c47d359" => :sierra
    sha256 "cbaa33bb9a6527f07beb21c1a6b2eaf0383d10a457e15fb02e415ad6223b4c4d" => :el_capitan
  end

  head do
    url "https://github.com/andreabolognani/cattle.git"

    depends_on "gtk-doc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    pkgshare.mkpath
    cp_r ["examples", "tests"], pkgshare
    rm Dir["#{pkgshare}/{examples,tests}/{Makefile.am,.gitignore}"]

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "sh", "autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath
    cp_r (pkgshare/"tests").children, testpath
    system ENV.cc, "common.c", "run.c", "-o", "test",
           "-I#{include}/cattle-1.0",
           "-I#{Formula["glib"].include}/glib-2.0",
           "-I#{Formula["glib"].lib}/glib-2.0/include",
           "-L#{lib}",
           "-L#{Formula["glib"].lib}",
           "-lcattle-1.0", "-lglib-2.0", "-lgio-2.0", "-lgobject-2.0"
    assert_match "Unbalanced brackets", shell_output("./test program.c 2>&1", 1)
  end
end
