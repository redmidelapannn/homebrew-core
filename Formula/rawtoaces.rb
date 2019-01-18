class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 4

  bottle do
    sha256 "e5ec42f6014c78563c4dde4313bcc36b5071bec87531c81efe30bc19d85aa54a" => :mojave
    sha256 "aba90d2e03b03c40cdbad660624ab218d7c584bca65ab08608009b41913eddaa" => :high_sierra
    sha256 "2239f2ed2364dde4dc4e11840705fcba0db4851415c45708db8d48fc3a4fca61" => :sierra
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
