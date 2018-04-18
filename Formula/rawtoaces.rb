class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 1

  bottle do
    rebuild 1
    sha256 "1c10db243ca41e5429f1a5b883caf5adc9ac544f7b86a803b08c3e47a447e102" => :high_sierra
    sha256 "14022b603acff68130f9bd4f34fec297420e3f6c8f386fcd78c023ef95c82899" => :sierra
    sha256 "161f1ff5a362985a30c064f659b043e11a7fe5a51ed718100a34d0b6b9221b27" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
