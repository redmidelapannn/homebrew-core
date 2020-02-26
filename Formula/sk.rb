class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.8.0.tar.gz"
  sha256 "42ac516aba6c9116fe96ff9dc5ac22fc7b14f809fbcdb5aaf93b9b36955da4dc"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "157f9a4d43deb58819eecbde8bc855dfd4a74cbc8f238a3638b546557d79eafb" => :catalina
    sha256 "2f7b5f9b5e3c1959fee9de90edff3da62c62a72cbd15037c9747c8043bfd7b66" => :mojave
    sha256 "6e35261c746c30aaa57f55252436358c9381f8193d81d43281b05a556baad507" => :high_sierra
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
