class CloogAT015 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://repo.or.cz/w/cloog-ppl.git"
  url "https://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  mirror "https://mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  sha256 "7cd634d0b2b401b04096b545915ac67f883556e9a524e8e803a6bf6217a84d5f"

  bottle do
    cellar :any
    rebuild 2
    sha256 "96bfcb7f60b1e8f2c9881121a21ad34820354d9da1d3553ae715dc75c4415070" => :high_sierra
    sha256 "e8ccadb7f61a8a09e1f75d32109d5ff4f7f4a8e67304ed66c1662d70e9058cd1" => :sierra
    sha256 "f5773d8143c2043fd158603e5ffc953aeddbb93736ac196bee044528b74dafc7" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "gmp@4"
  depends_on "ppl@0.11"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-gmp=#{Formula["gmp@4"].opt_prefix}"
      --with-ppl=#{Formula["ppl@0.11"].opt_prefix}"
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "CLooG", shell_output("#{bin}/cloog --help", 1)
  end
end
