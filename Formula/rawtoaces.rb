class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 9

  bottle do
    sha256 "7380a9638c2b7492ba3263d5761042e28956ed58494521252490d9c4c9aa9f27" => :catalina
    sha256 "0e191bad042eb08fcb815d3980c0a02f171daa1793151c3c2312a1fc6900bf1e" => :mojave
    sha256 "653b8cfe89161b163505e704efe06fa6f28f8e364bea89c2069157659a12c618" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
