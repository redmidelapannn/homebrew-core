class Sn0int < Formula
  desc "OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.7.0.tar.gz"
  sha256 "3074f1adbdc6f15ff2d9f8c8b5c5ada19266d7efaf9a21dfc044be08c220ab03"

  bottle do
    cellar :any_skip_relocation
    sha256 "16c5b4a0c21a7cb5264121abb62e1d47ee65c6cdca5a24c94bd69f68a226516f" => :mojave
    sha256 "64b8e7f4545c583977bfb00584f1857d2ffa45554c9a32eaf1b0526f437bcc43" => :high_sierra
    sha256 "cf8ca88032b78874412d98daf03e0592d776e9d78ae68ad0e0a4fb1b6dba9429" => :sierra
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvf", testpath/"true.lua"
  end
end
