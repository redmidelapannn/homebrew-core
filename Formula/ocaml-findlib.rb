class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 4

  bottle do
    sha256 "25fb9f89baa3fcce4319d0ca74283bcb1aa13786f53d3802f5840598fa770d7a" => :catalina
    sha256 "112f5febf7543d5ec88b71cc43eb87efa846e94ab1815e4be9b583bb4c97284b" => :mojave
    sha256 "86e0c224bb96899632fb563675c9973645a69079f96882327e29ddbbafbc1eca" => :high_sierra
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", lib/"ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-topfind"
    system "make", "all"
    system "make", "opt"
    inreplace "findlib.conf", prefix, HOMEBREW_PREFIX
    system "make", "install"

    # Avoid conflict with ocaml-num package
    rm_rf Dir[lib/"ocaml/num", lib/"ocaml/num-top"]
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
