class Chruby < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/postmodern/chruby#readme"
  url "https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz"
  sha256 "7220a96e355b8a613929881c091ca85ec809153988d7d691299e0a16806b42fd"

  head "https://github.com/postmodern/chruby.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bd5e1cccf1837a9c7e30f7289efbb8ee848cbfb2904648ad20ea591ed5c8d20e" => :sierra
    sha256 "bd5e1cccf1837a9c7e30f7289efbb8ee848cbfb2904648ad20ea591ed5c8d20e" => :el_capitan
    sha256 "bd5e1cccf1837a9c7e30f7289efbb8ee848cbfb2904648ad20ea591ed5c8d20e" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add the following to the ~/.bashrc or ~/.zshrc file:
      source #{opt_share}/chruby/chruby.sh
    EOS
  end
end
