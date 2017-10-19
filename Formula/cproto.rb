class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7m.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cproto/cproto_4.7m.orig.tar.gz"
  sha256 "4b482e80f1b492e94f8dcda74d25a7bd0381c870eb500c18e7970ceacdc07c89"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "823fd80d24c0b9693f3f5154edaae0e58f78485860bae94589b336fddfc6ac22" => :high_sierra
    sha256 "71dbb79b7dfc900863dfc75e1df7670c08c507b2ef0086cb75d8e22efa1e38b1" => :sierra
    sha256 "ba158780cea53d837c69cac95ca021b280ae22f4da7cf6403d1d2b9e92527af8" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
