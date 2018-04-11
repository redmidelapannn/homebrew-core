class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 2

  bottle do
    sha256 "4f3172d412437933cb4df3633b1c0784a4e575a93aa14cf9f098f6aafbbcb774" => :high_sierra
    sha256 "d6e473a47cab59109009f7aeae3d1df0937b548c545c625ab73b4b3311aebedd" => :sierra
    sha256 "b0fa4de5b19887aa4475785439e0fe49f86fc78d464e8145c5bd774125ee491e" => :el_capitan
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
