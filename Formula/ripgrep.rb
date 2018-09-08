class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.10.0.tar.gz"
  sha256 "a2a6eb7d33d75e64613c158e1ae450899b437e37f1bfbd54f713b011cd8cc31e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "9aa23dac90f133c58c7ac69d53eaca4550e12a23b0c4741e7e436eb957b35849" => :mojave
    sha256 "d12d7933090a913801e8f8bf43039409ff9e4f60a270bc20aa70e97a5783ed1e" => :high_sierra
    sha256 "05241afd9845ef7dbe99d104cd8551b354422275cb635ce6904d68c1e7881f17" => :sierra
    sha256 "a0383557f24f5d6e187b3652f2226b51e7204bc0427d6cdda6d86e0d05b8a1df" => :el_capitan
  end

  option "with-pcre2", "Enable PCRE2 support"

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "rust" => :build
  depends_on "pcre2" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      cargo
      install
      --root
      #{prefix}
      --path
      .
    ]

    args << "--features=pcre2" if build.with? "pcre2"

    system *args

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
