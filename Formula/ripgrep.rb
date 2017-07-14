class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.2.tar.gz"
  sha256 "5d880c590cbb09d907d64ba24557fb2b2f025c8363bcdde29f303e9261625eea"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    rebuild 1
    sha256 "66fd59ea6af28be54216747cc84f61c024fecdec781d0e59c763ed83025767d6" => :sierra
    sha256 "ed2d030a5aa31b87c17d286553580987649300416bab404309c19c624aaa93fd" => :el_capitan
    sha256 "112fe980f3b4ff221b0f09e0149375ee0523cbdb1604b09aa9a4463e93f9de44" => :yosemite
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
    if build.head?
      zsh_completion.install "complete/_rg"
    else
      zsh_completion.install "#{out_dir}/_rg"
    end
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
