class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.10.0.tar.gz"
  sha256 "a2a6eb7d33d75e64613c158e1ae450899b437e37f1bfbd54f713b011cd8cc31e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "56cefaa7e5fb8c6620b654287e4b89f6a43f972c73f27498d8dc251353a881c3" => :mojave
    sha256 "6ff5d1dfccaf792846750505a3cf380914472adca7665a3ce070818fed050719" => :high_sierra
    sha256 "36d2c7716828740bbf267439623870d2a832f4cabc6b574ecbbe5df8d6ea0eb3" => :sierra
    sha256 "d28c7c5fe93581a875fd33e611df7ebd659f7597c731b32e86ebb072f6840fce" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "rust" => :build

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--root", prefix, "--path", "."

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
