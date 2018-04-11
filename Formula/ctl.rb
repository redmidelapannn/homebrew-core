class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 2

  bottle do
    sha256 "0710a11b85d449226ac410fba8bcb5e78d4a7f34a1695600f9257fdb9e0a97d2" => :high_sierra
    sha256 "0350b865e850d65bc55cec0f9733609aa7798fb03e69b0681b889de4f9b46c63" => :sierra
    sha256 "6fd5ba3efa39bceef631d6033565b6b2d55c547fa45fe57841ce48a72eb46c1e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libtiff"
  depends_on "ilmbase"
  depends_on "openexr"
  depends_on "aces_container"

  def install
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    assert_match /transforms an image/, shell_output("#{bin}/ctlrender -help", 1)
  end
end
