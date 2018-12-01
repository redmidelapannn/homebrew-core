class Skim < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.5.2.tar.gz"
  sha256 "41280bee2138afefff95f76a640b753d1cb9215e8391ef37eab7ccb3517d9019"

  bottle do
    sha256 "4f3fa07825b9a9a1835b72cecf4b1f5e13ec03bb53bf42b38e5f01f14b3ee667" => :mojave
    sha256 "e4ce983171199d05f35c27bfff3035ad494fc113bfd60c4d486d55ea7820c2fc" => :high_sierra
    sha256 "c943bb63cdf4324394d93eecda07e764f7e938fd51a34958bf954753f42da5d5" => :sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--root", prefix, "--path", "."

    prefix.install "install"
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/skim.vim"
    bin.install "bin/sk-tmux"
  end

  def caveats; <<~EOS
    To install useful keybindings and fuzzy completion:
      #{opt_prefix}/install
    To use skim in Vim, add the following line to your .vimrc:
      set rtp+=#{opt_prefix}
  EOS
  end

  test do
    system "#{bin}/sk", "--version"
  end
end
