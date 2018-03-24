class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1726/lablgtk-2.18.6.tar.gz"
  sha256 "4ddca243066418e2a88ac49ebf2d846fac4b667b1b1753efadd078ae777368f8"
  revision 1

  bottle do
    rebuild 1
    sha256 "8f7b715236cd580a65fb689fcd40f2deb8d80f28d0af5090ce0772d10a2bd213" => :high_sierra
    sha256 "bd8210ffdcefc914dc31385c4b24cf445e4017d11df5e2bb1baf9009efd3d3dc" => :sierra
    sha256 "cb3ebce518cc5d14d917e3f9e275fd9b6bd060cd8f43558be20ce46077c10e99" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "camlp4" => :build
  depends_on "ocaml"
  depends_on "gtk+"
  depends_on "librsvg"
  depends_on "gtksourceview"

  def install
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{lib}",
                          "--mandir=#{man}",
                          "--with-libdir=#{lib}/ocaml"
    ENV.deparallelize
    system "make", "world"
    system "make", "old-install"
  end

  test do
    (testpath/"test.ml").write <<~EOS
      let _ =
        GtkMain.Main.init ()
    EOS
    ENV["CAML_LD_LIBRARY_PATH"] = "#{lib}/ocaml/stublibs"
    system "ocamlc", "-I", "#{opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml", "-o", "test",
      "-cclib", "-latk-1.0",
      "-cclib", "-lcairo",
      "-cclib", "-lgdk-quartz-2.0",
      "-cclib", "-lgdk_pixbuf-2.0",
      "-cclib", "-lgio-2.0",
      "-cclib", "-lglib-2.0",
      "-cclib", "-lgobject-2.0",
      "-cclib", "-lgtk-quartz-2.0",
      "-cclib", "-lgtksourceview-2.0",
      "-cclib", "-lintl",
      "-cclib", "-lpango-1.0",
      "-cclib", "-lpangocairo-1.0"
    system "./test"
  end
end
