class Aamath < Formula
  desc "Renders mathematical expressions as ASCII art"
  homepage "http://fuse.superglue.se/aamath/"
  url "http://fuse.superglue.se/aamath/aamath-0.3.tar.gz"
  sha256 "9843f4588695e2cd55ce5d8f58921d4f255e0e65ed9569e1dcddf3f68f77b631"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b4a100ef096aac3ae3d11311a4afe052c79f1af4180790d85470ffdb940dc8d" => :catalina
    sha256 "d01d6c93eb24bfb0a80aa48588bd0447787da5326f0006638d9e5fc4cc181397" => :mojave
    sha256 "679108af1d56dcb07202f8062cb7c3974025d77240d35bf1e09757c75b09a1ce" => :high_sierra
  end

  uses_from_macos "bison" => :build # for yacc
  uses_from_macos "flex" => :build
  uses_from_macos "readline"

  # Fix build on clang; patch by Homebrew team
  # https://github.com/Homebrew/homebrew/issues/23872
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aamath/0.3.patch"
    sha256 "9443881d7950ac8d2da217a23ae3f2c936fbd6880f34dceba717f1246d8608f1"
  end

  def install
    ENV.deparallelize
    system "make"

    bin.install "aamath"
    man1.install "aamath.1"
    prefix.install "testcases"
  end

  test do
    s = pipe_output("#{bin}/aamath", (prefix/"testcases").read)
    assert_match /#{Regexp.escape("f(x + h) = f(x) + h f'(x)")}/, s
  end
end
