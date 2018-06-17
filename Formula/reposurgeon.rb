class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      :tag => "3.44",
      :revision => "f37fa1aa8e3235bb4c64cbcd9e85a6907b4dea50"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d93c430a005ee5ce136a69970d686bbd4c6c97a93a201cadec2f221eca87b1b9" => :high_sierra
    sha256 "c85238c4f5d4e5d36cfa9b938111b2b7c9452642340cf2535c26381176f68bdc" => :sierra
    sha256 "45319255a14ad7098877ff0613a2b27e80d340422cbd95fd350925fdf858ce7a" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "pypy"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
