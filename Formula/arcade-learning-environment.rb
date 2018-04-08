class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "94b38ae395565819fa586a4e0387e49fc4f2e408eed2d351191525d64603484d" => :high_sierra
    sha256 "6ac7e4d93544031c0a0b5a39d502625088eaf0afadcc72a250ca3364ebd3f3de" => :sierra
    sha256 "a6c4733ec5d20505d87f31baaca1d8338e7373a169f557d72f1e51e0ca958b5f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python@2"
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
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
