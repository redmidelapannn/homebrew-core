class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.7.3.tar.gz"
  sha256 "d196608fa23c36c2aace27d5ef124a815132a5fcea668d41fa7d6c1ca246bd8b"

  depends_on "ocaml"

  def install
    ENV.deparallelize # See https://gitlab.camlcity.org/gerd/lib-findlib/merge_requests/8
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", lib/"ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-topfind"
    system "make", "all"
    system "make", "opt"
    inreplace "findlib.conf", prefix, HOMEBREW_PREFIX
    system "make", "install"
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", shell_output("#{bin}/ocamlfind query findlib").strip
  end
end
