class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/direnv/direnv/archive/v2.9.0.tar.gz"
  sha256 "023d9d7e1c52596000d1f4758b2f5677eb1624d39d5ed6d7dbd1d4f4b5d86313"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6776d0330f0550e7fd3cd04ad1c5691473bf0e65c3b03eae317411e956e907a2" => :sierra
    sha256 "098361b6594e2c44dd73d7f6482429e8c610ed230c2e6ec56c3067566be90a7b" => :el_capitan
    sha256 "47704fe9d4004fa1b46dc9159e9330aefd03e91bcc33d66abcfc0495ad6c61bc" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For direnv to work properly it needs to be hooked into the shell.
    Each shell has its own extension mechanism:

    Bash
      Add the following line at the end of the "~/.bashrc" file:
        eval "$(direnv hook bash)"
      Make sure it appears even after rvm, git-prompt and other shell extensions
      that manipulate the prompt.

    Zsh
      Add the following line at the end of the "~/.zshrc" file:
        eval "$(direnv hook zsh)"

    Fish
      Add the following line at the end of the "~/.config/fish/config.fish" file:
        eval (direnv hook fish)

    Tcsh
      Add the following line at the end of the "~/.cshrc" file:
        eval `direnv hook tcsh`
    EOS
  end

  test do
    system bin/"direnv", "status"
  end
end
