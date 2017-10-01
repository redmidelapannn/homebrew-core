class CloogAT015 < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://repo.or.cz/w/cloog-ppl.git"
  url "ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  mirror "https://mirrorservice.org/sites/sourceware.org/pub/gcc/infrastructure/cloog-ppl-0.15.11.tar.gz"
  sha256 "7cd634d0b2b401b04096b545915ac67f883556e9a524e8e803a6bf6217a84d5f"

  bottle do
    cellar :any
    rebuild 2
    sha256 "97aee54d30ed660b361039b1782d5e3a233aa259c5b6f21008a17ecb122fe4b9" => :high_sierra
    sha256 "4c9f0e26713afb6b0069b8d7fcbb70df708e15452f0d958cff52aee23e0773bd" => :sierra
    sha256 "72479c728502427a1778499b73bfdc7dd89262e349230af6798f938a93eceb74" => :el_capitan
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
