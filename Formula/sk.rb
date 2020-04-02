class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.8.1.tar.gz"
  sha256 "66eab31697b7bb373e6e26aa62e0c76f725f36269da105197f447489f6ec477b"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "954a580746e8045d1a2a2d53242ad35558ad39e5c2a64312f02b235d6a3de764" => :catalina
    sha256 "80c3b592435c870c7484bb62ee3a49009dd99455108de6ccf034f59d238ecc13" => :mojave
    sha256 "42d8366726e0603146cdebbde8a2b8cac7c56741aa9baa75e7ce58f85e278720" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match /.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld")
  end
end
