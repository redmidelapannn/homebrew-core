class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.3.tar.gz"
  sha256 "74057678642080d193a9f65a804612e1d5b87da5a1f82ee487bbc44eb34993f2"
  revision 1
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "10ced32519f4dcca7f7610195115d94a78bb51ec49672affefe3325e7da1ac75" => :catalina
    sha256 "f4fb170f81de129558df604149bc6b17b39f711ab04366aeeb845b10ced45417" => :mojave
    sha256 "1281a322a8260ed6f33ca7c15bad19671a3af1ceed25e2a71a683014f66c8754" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  def install
    args = std_cmake_args + %W[
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
    ]
    system "cmake", ".", *args
    system "make", "install"

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
