class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.21.0.tar.gz"
  sha256 "89870f9f9396f41adc3609d466caab7556d831a1ad726cc6132a880febfd0eec"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "918719cab406f197a483391e0c26d15a8daf574ce12508edcff64da6a1b44427" => :catalina
    sha256 "883c970f98a88d44183ddfe25c2dc6f2e4c6b8079bc2c968f20cc3036f6cdd17" => :mojave
    sha256 "562bef46072f6a0697088951146ca270f0c069df8c379cd61fa38dc803b90426" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    system "go", "build", "-o", bin/"fzf", "-ldflags", "-X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats; <<~EOS
    To install useful keybindings and fuzzy completion:
      #{opt_prefix}/install

    To use fzf in Vim, add the following line to your .vimrc:
      set rtp+=#{opt_prefix}
  EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
