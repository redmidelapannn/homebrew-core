class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 13

  bottle do
    cellar :any
    sha256 "ac343c6d1d6a4f6275d13c17caded511719a0902fed4cf7dd662267788650734" => :catalina
    sha256 "d07a34da886e1a70fbab5d19db5d655950c5b7b05f171454f5a138a6653fe17f" => :mojave
    sha256 "2ac7a5e61be95e296839bbe7184c80413c5ed83a83bb35ebdbe5df643da2af19" => :high_sierra
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
