require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.4/cgrep-6.6.4.tar.gz"
  sha256 "c192928788b336d23b549f4a9bacfae7f4698f3e76a148f2d9fa557465b7a54d"
  revision 1
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "9dd3c7f9c5ff96b5c7faba00c82d6b9724c8a0bad3b55b53f84b57282d5d97f9" => :el_capitan
    sha256 "1a6ecae052ae4b8fab41254f2a467889f63ef62308ea9d89bcdf0b7a306f71e6" => :yosemite
    sha256 "2ecffac56dfb48ef7e812b58eda241aac37e7ac36b98511c200e1f2b27b4c5c8" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    path = testpath/"test.rb"
    path.write <<-EOS.undent
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --comment test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --literal test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --code puts #{path}")
  end
end
