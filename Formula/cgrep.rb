require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.17.tar.gz"
  sha256 "2508563701365d9b49c9a5610a4ff7ea3905b2d9cd77ac332f485322d93bcd07"
  revision 1
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "134387f06360c77c2e2cdcb42db48ddaf7480cd11302818792ab195171a0f4ff" => :sierra
    sha256 "6b69494a08742ffb9038c6611f63a36f35eeb88dc8f42fb57b7daa8e37641ec8" => :el_capitan
    sha256 "6b4341269eec195f9d3c1a91785c1822934c009f6bac97be407cfaaf49c4280f" => :yosemite
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
