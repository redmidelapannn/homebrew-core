class Aamath < Formula
  desc "Renders mathematical expressions as ASCII art"
  homepage "http://fuse.superglue.se/aamath/"
  url "http://fuse.superglue.se/aamath/aamath-0.3.tar.gz"
  sha256 "9843f4588695e2cd55ce5d8f58921d4f255e0e65ed9569e1dcddf3f68f77b631"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9cf8261e7da70b486c8369761c08838c1276d1a19b12fdaee7e3c3cf0bba1a7e" => :catalina
    sha256 "4523c696731fea8ca1e1ee8ce1946578ca918a6a8ec3d10d9852976ed93c1963" => :mojave
    sha256 "367af88f8eb5d5faa8c3a7da778f993d11a207c964b67ca29e884933f3290440" => :high_sierra
  end

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
