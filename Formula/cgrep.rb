require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.19.tar.gz"
  sha256 "932237b12f1802c884d3eb11044e0f38f09e21f7bcebe56e05e7902b40e4ec55"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d7e562ddc986e470e30073e9275d4e7df2dd252b43eb7a13802bfa5933a178d" => :high_sierra
    sha256 "ef9ced1ee6ce0d930cdad1bd0bfee096ca6968cb311ca159d33ac65380551f80" => :sierra
    sha256 "9d4c2d0d1beb7a83dce7c7565c6d0209e7d6eefcfdb45bda68fbd30d4538d3a3" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    input = <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    cmd = "#{bin}/cgrep --language-force=ruby --count --comment test"
    assert_match ":1", pipe_output(cmd, input, 0)
    cmd = "#{bin}/cgrep --language-force=ruby --count --literal test"
    assert_match ":1", pipe_output(cmd, input, 0)
    cmd = "#{bin}/cgrep --language-force=ruby --count --code puts"
    assert_match ":1", pipe_output(cmd, input, 0)
    cmd = "#{bin}/cgrep --language-force=ruby --count puts"
    assert_match ":2", pipe_output(cmd, input, 0)
  end
end
