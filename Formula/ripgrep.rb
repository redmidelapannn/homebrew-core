class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.0.tar.gz"
  sha256 "8e210c7486cfb2a782cb0aab0c5eb7c1fae606b4279254b491a084c8da84c11d"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    rebuild 1
    sha256 "424c5757e297365ca5f553839893af4f1050eaa3193749f70fc166b6beaeb3ea" => :sierra
    sha256 "632f1214861549ec27e914d89f9b644bf426b0a6d8239d4fab320491f2b8d59d" => :el_capitan
    sha256 "1e74aee654944864b433667f3fb501aa402402772b701fed4652b2e79aec969a" => :yosemite
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
