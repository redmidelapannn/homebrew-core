class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.7.3.tar.gz"
  sha256 "d196608fa23c36c2aace27d5ef124a815132a5fcea668d41fa7d6c1ca246bd8b"

  depends_on "ocaml"

  def install
    ENV.deparallelize

    system "./configure", "-bindir", "#{HOMEBREW_PREFIX}/bin",
                          "-mandir", "#{HOMEBREW_PREFIX}/share/man",
                          "-sitelib", "#{HOMEBREW_PREFIX}/lib/ocaml",
                          "-config", "#{HOMEBREW_PREFIX}/etc/ocamlfind.conf"
    system "make", "all"
    system "make", "opt"
    system "make", "install", "prefix=#{buildpath}/output/"
    prefix.install Dir["output/#{HOMEBREW_PREFIX}/*"]
  end

  test do
    system "#{bin}/ocamlfind", "query", "findlib"
  end
end
