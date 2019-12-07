class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  revision 2

  bottle do
    sha256 "e85663c19d5ea637fbbfbb9e5bbe00aede5c1fc5f26368151d14f109ab9b44fa" => :catalina
    sha256 "988a5ff3a71c5eb333682691a1e8aa38bc170f357a407f266713388826d3295a" => :mojave
    sha256 "933b4817decc163ac44f37f16f1d8874183c6ffea5a4ffa417977ffe69b2e92a" => :high_sierra
  end

  depends_on "ocaml"

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
