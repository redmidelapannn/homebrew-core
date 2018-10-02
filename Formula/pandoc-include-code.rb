require "language/haskell"

class PandocIncludeCode < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.3.0.0/pandoc-include-code-1.3.0.0.tar.gz"
  sha256 "84c5f27a358b4a39606761157de93152c304b3a7d4e27cd30391c2a93cd495ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "6af4864b4b6d5df784422d29d136ca22e1d1029e027414de83f2b514af0cf7ab" => :mojave
    sha256 "77a2c346b4487e89f67af6ed23e1d9bed1a199e826f008d743074bd7bdf1fd4f" => :high_sierra
    sha256 "9bcd6d66b739f12c82afda72a9effe55d318081caa42907efcae82c7bc9150f5" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"include-demo.md").write <<~EOS
      Demo for pandoc-include-code.
      A simple C code from source file.

      ```{include=hello.c}
      ```
    EOS
    (testpath/"hello.c").write <<~EOC
      #include <stdio.h>
      int main(){
        print("Hello, World!");
      }
    EOC
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-include-code", "-o", "out.html", "include-demo.md"
    assert_match "Hello, World!", (testpath/"out.html").read
  end
end
