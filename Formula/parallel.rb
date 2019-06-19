class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190522.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190522.tar.bz2"
  sha256 "5bc60a65902102eb080690cd4cf168bc99f74a467ee9c7ff98ea0dbd3c4f7f78"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b4a5201e2cee05a20d436f5eccb513af38d787c4c14d6bb3d74d2a02e290b5df" => :mojave
    sha256 "b4a5201e2cee05a20d436f5eccb513af38d787c4c14d6bb3d74d2a02e290b5df" => :high_sierra
    sha256 "2aae326a14c37fdfaf69c7f8446e35377758d72d386b4895448e750912b19713" => :sierra
  end

  conflicts_with "moreutils",
    :because => "both install a `parallel` executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
