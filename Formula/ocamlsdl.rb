class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 7

  bottle do
    cellar :any
    rebuild 1
    sha256 "53851d2cba91f8f5076167bd217bbe9fa1cb55340bd66db38f9f426a1b185762" => :high_sierra
    sha256 "e828337db4b3f23b98a63bdb7b50105833878313272fefec0e3103ac5f084edc" => :sierra
    sha256 "bab45c9f8ea55ae3337e1f49ef4985651e2e9a3b6b8775087f66cb99d51f008b" => :el_capitan
  end

  depends_on "sdl"
  depends_on "ocaml"
  depends_on "sdl_mixer" => :recommended
  depends_on "sdl_image" => :recommended
  depends_on "sdl_gfx" => :recommended
  depends_on "sdl_ttf" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "OCAMLLIB=#{lib}/ocaml"
    system "make", "OMLFLAGS = -unsafe -unsafe-string",
                   "MLFLAGS=-g -unsafe-string"
    system "make", "install"
  end

  test do
    (testpath/"test.ml").write <<~EOS
      let main () =
        Sdl.init [`VIDEO];
        Sdl.quit ()

      let _ = main ()
    EOS
    system "#{Formula["ocaml"].opt_bin}/ocamlopt", "-I", "+sdl", "sdl.cmxa",
           "-cclib", "-lSDLmain", "-cclib", "-lSDL", "-cclib",
           "-Wl,-framework,Cocoa", "-o", "test", "test.ml"
    system "./test"
  end
end
