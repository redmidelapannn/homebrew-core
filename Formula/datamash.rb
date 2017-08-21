class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.1.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.1.1.tar.gz"
  sha256 "420819b3d7372ee3ce704add847cff7d08c4f8176c1d48735d4a632410bb801b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c7a7a81e479b675a94873234bc5a224fd7b5d4aa26c0101706a8d89c168304c" => :sierra
    sha256 "dc008109ca240a4347b63530b9e66057dd3bb38763599035d173788c9df1aec6" => :el_capitan
    sha256 "f693badc447599c9b1441d71671444b690ded932ab21ac7b7dcf40d13f19bad1" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", shell_output("seq 10 | #{bin}/datamash sum 1").chomp
  end
end
