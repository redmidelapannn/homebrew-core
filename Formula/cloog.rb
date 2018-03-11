class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://www.bastoul.net/cloog/"
  url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 2

  bottle do
    cellar :any
    sha256 "0133d815343a26762ac6938b8f089f3ce3b699adb0ccfef2960ba11881cb8e4d" => :high_sierra
    sha256 "506b9121ccf842e516ff20e38a852d70bf2b2fafa1efab6825af24e28f86f4a8" => :sierra
    sha256 "5db5643738fbe35f6bb88ff4df8ba76d18d39d72eeb9f37e835203d3244a8613" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  # Compatability for isl 0.19
  # Patch taken from https://github.com/periscop/cloog/pull/38
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9332a900cb98eaf471abd5eaf82291f8d63abc79/cloog/cloog-isl0.19-compat.diff"
    sha256 "ef3828a30df91ca78c3181aabb194881edb5642db178b3cbcadd8702a59cb1d2"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{Formula["isl"].opt_prefix}"
    system "make", "install"
  end

  test do
    cloog_source = <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match %r{Generated from /dev/stdin by CLooG}, output
  end
end
