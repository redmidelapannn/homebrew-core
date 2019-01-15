class Rawtoaces < Formula
  desc "RAW to ACES Utility"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  revision 4

  bottle do
    sha256 "4d9aa67f8675219aa6d93c32df13e97b67007b3b40a663a10f9a8036058a06b5" => :mojave
    sha256 "80b0d7ee61e8f41aa5fe69a91fae26e7c5bd175114ccfcd0dfae9559cdb29533" => :high_sierra
    sha256 "eeb8ef077cb74b6b5735b0195ac9c0d5200707c28ca127d59dd89a33a5be55b0" => :sierra
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
