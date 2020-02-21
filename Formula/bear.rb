class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.3.tar.gz"
  sha256 "74057678642080d193a9f65a804612e1d5b87da5a1f82ee487bbc44eb34993f2"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "6458a364fc7641781e72fb695d98c1ea758ed3082da629ca4402a0adaa93d9bf" => :catalina
    sha256 "208a9ef8104bd8d3d80ef6ccc6fb9e14dc48210c56a350f2384511d29c0608d2" => :mojave
    sha256 "6819f9b3ab29aa707e8965384eccde96e37f6d1ba37b34d6521a814873042af6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  def install
    args = std_cmake_args + %W[
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3.8
    ]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
