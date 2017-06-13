class AutopanoSiftC < Formula
  desc "Find control points in overlapping image pairs"
  homepage "https://wiki.panotools.org/Autopano-sift-C"
  url "https://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz"
  sha256 "9a9029353f240b105a9c0e31e4053b37b0f9ef4bd9166dcb26be3e819c431337"

  bottle do
    cellar :any
    rebuild 1
    sha256 "47bc2bd5137cf9ea5ae65a790038d69254dd770fdd93a86f2f72f05db85fe962" => :sierra
    sha256 "7e552447ba49b1eb27fc2af20bcd96f612b85754f5540bbb8930c7d9b4462ffc" => :el_capitan
    sha256 "432f3d1b107c832b8c7e228e69a222a9da82703b79cf59953dbac641f3686bc6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpano"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", pipe_output("#{bin}/autopano-sift-c")
  end
end
