class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.0.tar.gz"
  sha256 "8e210c7486cfb2a782cb0aab0c5eb7c1fae606b4279254b491a084c8da84c11d"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    rebuild 1
    sha256 "829ead15ebc0228e1874babda51f14e376c778672737b21c3b4b33ed1429d4f3" => :sierra
    sha256 "98a301eea93c37ecaa38e101f88a5f896bed1cc4b18a527cf48d23ef70075a95" => :el_capitan
    sha256 "9e824ab5ed73ec6a94f198a7f5e83c7611487c47ed02cd8655bee1383dbd4cf9" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/rg"
    man1.install "doc/rg.1"

    # Completion scripts are generated in the crate's build directory, which
    # includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    bash_completion.install "#{out_dir}/rg.bash-completion"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "#{out_dir}/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
