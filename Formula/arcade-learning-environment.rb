class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  revision 1
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "edd09b88d736f1b5d25389515da3d45500f57cd234a75966b2fccb8c4fa05577" => :high_sierra
    sha256 "f5badb2621a453ae64afed896421d49f00f8927bc5b81b34c07d509eedfcca42" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python@2"
  depends_on "sdl"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]

    system "cmake", ".", *args
    system "make", "install"
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{bin}/ale 2>&1", 1).lines.last.chomp
    assert_equal "No ROM File specified.", output
    (testpath/"test.py").write <<~EOS
      from ale_python_interface import ALEInterface;
      ale = ALEInterface();
    EOS
    assert_match "ale.cfg", shell_output("python test.py 2>&1")
  end
end
