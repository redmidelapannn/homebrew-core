require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.32.tar.gz"
  sha256 "c45d680a2a00ef9524fc921e4c10fc7e68f02e57f4d6f1e640b7638a2f49c198"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "55bc38085cd537cffe73c2fae34157b51f10f05b0f224746aba0e6430bb6aca1" => :catalina
    sha256 "1117b18dbf472cf4f8d90c75f96a921f6c66fc2942848a7c98e6fd48e78e8e09" => :mojave
    sha256 "e924e4f4a877dbd071222ef67acc94659a7ce7af0ce38ad95192ad5014f60fac" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
