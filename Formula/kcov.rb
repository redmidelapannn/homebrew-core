class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/38.tar.gz"
  sha256 "b37af60d81a9b1e3b140f9473bdcb7975af12040feb24cc666f9bb2bb0be68b4"
  head "https://github.com/SimonKagstrom/kcov.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c1fe24c1ce5643b0426e39f4573d5d9b3a3eac87aabcd4d8d27657bc2689e77e" => :catalina
    sha256 "c074ed62620d746ed1edc65a835230aa6683d211b6a58bb387588037e64185bc" => :mojave
    sha256 "793c3c817a68462556e182af2c9a121304a2b49128e21458f2799d3bf46a5fe5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on :macos # Due to Python 2

  def install
    mkdir "build" do
      system "cmake", "-DSPECIFY_RPATH=ON", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
