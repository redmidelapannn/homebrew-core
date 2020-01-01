class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.3-Source.tar.xz"
  sha256 "b111c15fdc8c029989330ff559184198c161100a59312f5dc19ddeb9b5a15889"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e17c2437f5ad1977ac2dc5d90d595e67f4639de0fadcbcb2912b82a159cb7a8f" => :catalina
    sha256 "364306e1c0e7e77ccd684cc798dd8803b50f7eedddb7c285ef346bdd3802ea7b" => :mojave
    sha256 "ca0535f099d23482b83a81b032ad84154b5a43bd58cc869d260c93174e8b01f4" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <soxr.h>

      int main()
      {
        char const *version = 0;
        version = soxr_version();
        if (version == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsoxr", "test.c", "-o", "test"
    system "./test"
  end
end
