class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.1.tar.gz"
  sha256 "8059a4087680da03878c1648a8ceb0413a341032ecaa44bef4ef1f9f829b6dde"
  revision 1
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "34e25cefc359f3e7c6951406b71407c43bde14e645ab3e589f5909259c445ae2" => :catalina
    sha256 "8bcbce6f017bcaa239296590bf6e311069c07ef337e23bf45ac14737e2d03890" => :mojave
    sha256 "e589403d3bff46eb5e8de13758cc370e31ed487426148931559aae0b5fbfc870" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python"
  depends_on "sdl"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{bin}/ale 2>&1", 1).lines.last.chomp
    assert_equal "No ROM File specified.", output
    (testpath/"test.py").write <<~EOS
      from ale_python_interface import ALEInterface;
      ale = ALEInterface();
    EOS
    assert_match "ale.cfg", shell_output("python3 test.py 2>&1")
  end
end
