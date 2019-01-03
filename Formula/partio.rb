class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.5.5.tar.gz"
  sha256 "25352a6af0ccc20794a8c85715d5a6645c3f8ddcb6bbaaf20136670b5abd4727"

  bottle do
    cellar :any
    sha256 "22109983d7b5b04aafdfe7fb4294b58cd1057dca16a17e9490829b8516715dd6" => :mojave
    sha256 "78384ed10f70a6634f56f4dcb461708c5ad95ea17db7df7090ade05557c04751" => :high_sierra
    sha256 "fd0a725f1ce1590370a84bdd6b3f537fe1b5df2330490db198199f5994d25489" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "swig" => :build

  resource "bgeo" do
    url "https://raw.githubusercontent.com/wdas/partio/dc898054d9144a409fe0e3f8d7f957e1a50ed8a1/src/data/test.bgeo"
    sha256 "b0fe4adcc043d59448cfe690389e45d0f49b6ead675b10d028ca3d70b85999e8"
  end

  def install
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
  end

  test do
    resource("bgeo").stage do
      assert_match "Number of particles:  5", shell_output("#{bin}/partinfo test.bgeo")
    end
  end
end
