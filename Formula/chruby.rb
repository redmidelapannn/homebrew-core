class Chruby < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/postmodern/chruby#readme"
  url "https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz"
  sha256 "7220a96e355b8a613929881c091ca85ec809153988d7d691299e0a16806b42fd"

  head "https://github.com/postmodern/chruby.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "db5b6931ee0ee103e80b022560e828e2c5a8b2929c94a0253c99a77446316ef4" => :sierra
    sha256 "7547ea517587a0e828e5e796598a8f5f460af591d7ab9bf97abdfc274b3048b0" => :el_capitan
    sha256 "7547ea517587a0e828e5e796598a8f5f460af591d7ab9bf97abdfc274b3048b0" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add the following to the ~/.bash_profile or ~/.zshrc file:
      source #{opt_share}/chruby/chruby.sh

    To enable auto-switching of Rubies specified by .ruby-version files,
    add the following to ~/.bash_profile or ~/.zshrc:
      source #{opt_share}/chruby/auto.sh
    EOS
  end
end
