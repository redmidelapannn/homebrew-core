class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.18.0.tar.gz"
  sha256 "5406d181785ea17b007544082b972ae004b62fb19cdb41f25e265ea3cc8c2d9d"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "36076f057ef210a6a9b65d4b3c2bf27c541fc1d5c0bad3d1c9214edcf96373bd" => :mojave
    sha256 "af1fd4406613b7747ff6adbb6d4467049a3e548bff4332154238479c38dd9901" => :high_sierra
    sha256 "aa7661aeb9d122629985a8ab87378bcb0b5005459b4fd249bccc510d731ba61f" => :sierra
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
