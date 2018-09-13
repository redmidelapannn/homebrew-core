class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 10

  bottle do
    cellar :any
    rebuild 1
    sha256 "61932ea6f7d6a809709fcbc8d3418574ebe002db48b9e78d7043cfc6369b7139" => :mojave
    sha256 "19fabe104c47125faef11ca035be9c6a6db3795148c8fb5b219ef88d648b777c" => :high_sierra
    sha256 "d7dfae68bd4acf507acd31aa9ebe373a2f30d6f2ee0e494a71d8b98ada2b415c" => :sierra
    sha256 "db8905dc1f6f8dd538c30fc376ed046a8fb6931834c54fdb122972bfca29244a" => :el_capitan
  end

  depends_on "ocaml"
  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat
    system "./configure", "--prefix=#{prefix}",
                          "OCAMLLIB=#{lib}/ocaml"
    system "make"
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
