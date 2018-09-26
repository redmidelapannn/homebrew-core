class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.1.tar.gz"
  sha256 "06534de715dbc614f08407000c2ec6d497770069a2d7c84defd421b137313d71"
  head "https://github.com/fabianishere/brainfuck.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd60713987a2f814b4601e8a5ad32590002b339fd0080710234933bab5150a6d" => :mojave
    sha256 "eb9ecdfc707ac5f4194bdfe714f1a8c016782a4854b45d1d88420f98b9980e12" => :high_sierra
    sha256 "1a764fdaafc1bbc1349e1a267a50e613366402824814a589d6e70644bf56c62c" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIB=ON",
                         "-DBUILD_STATIC_LIB=ON", "-DINSTALL_EXAMPLES=ON"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end
