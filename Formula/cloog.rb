class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://www.bastoul.net/cloog/"
  url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "307c70f26c27aede072f2e9326d8f987fe3f6f8f6df07419d9ceb1a7d024aadf" => :high_sierra
    sha256 "2c1f0ae1aa1bcc78da197b778e16c65b2ec7fe02ee383ddcf2035c774bffd7cb" => :sierra
    sha256 "1b8de47465bf2621e50b9e08f8e214a0d4d555278ea0e06cf81e290c6abdcb25" => :el_capitan
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
