class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 3

  bottle do
    sha256 "31ad07eab3cb56ecc23452e44f3904d8ded54a83eb68a09d9da5ada2f8fdd277" => :mojave
    sha256 "ac3908aec0cc6340466f62e9d700004e4df2f5a2e2c266541d48707fa1ac6710" => :high_sierra
    sha256 "7bbc4f13664ab48049197307a934350d28f2f3b54bdb54b991aa844bf5b50417" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr"

  # Patch to fix build against Ilmbase 3.2
  # https://github.com/ampas/CTL/issues/71
  patch do
    url "https://gist.githubusercontent.com/remia/3184420d763bc3005789ec346abe5408/raw/e1fe73e67ff973fb9b436a3ebe7d5e8c5ffb2e2d/patch-ilmctlsimd.diff"
    sha256 "2a4d9896a30c452a37532d71250621cf47e6844496f72b96aee75baee2ce64ed"
  end

  def install
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /transforms an image/, shell_output("#{bin}/ctlrender -help", 1)
  end
end
