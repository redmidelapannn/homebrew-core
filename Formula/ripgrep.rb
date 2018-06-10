class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.8.1.tar.gz"
  sha256 "7035379fce0c1e32552e8ee528b92c3d01b8d3935ea31d26c51a73287be74bb3"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    rebuild 1
    sha256 "ec021ce431b664d62af7854383663be49ec3d4c25ba21cd8e389ba0dcd734712" => :high_sierra
    sha256 "fab6d78565a9ebc0efa946283b1d2d360a54b226db52eef47daf8cbb28d659eb" => :sierra
    sha256 "b5eb8f4eb3ca92e83ae1e324843208a2bb2e6244e5cc77e56e906a4620f75dfb" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "rust" => :build

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--root", prefix

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    man1.install "#{out_dir}/rg.1"
    bash_completion.install "#{out_dir}/rg.bash"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
