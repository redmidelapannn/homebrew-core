class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
    :tag => "0.5.0",
    :revision => "15d4587514a3beaa13972093e335bf685b6726a9"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dde7c373240a8eafb20abd93b0c74aa2845008ebdcf11f5b21240e343b19de43" => :sierra
    sha256 "2dc2a89a408f6d7f9cbe61dba15c9452c2f4089eaf202b012bc35f1fcc36c8b5" => :el_capitan
    sha256 "dde7c373240a8eafb20abd93b0c74aa2845008ebdcf11f5b21240e343b19de43" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<-EOS.undent
    To activate the syntax highlighting, add the following at the end of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc

    Additionally, if you receive "highlighters directory not found" error message,
    you may need to add the following to your .zshenv:

      export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=#{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters
    EOS
  end

  test do
    assert_match "#{version}\n",
      shell_output("zsh -c '. #{pkgshare}/zsh-syntax-highlighting.zsh && echo $ZSH_HIGHLIGHT_VERSION'")
  end
end
