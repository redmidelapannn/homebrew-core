class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/r0mai/metashell/archive/v3.0.0-rc1.tar.gz"
  sha256 "bf788174279a11abdb8a84482482496255c73feabf4ba5c2b090f6a38acdb1b8"

  bottle do
    sha256 "4cc10f05904c9c5bac0d18889b52ad6be07591c7ad7785630b6cfd9b0e80a448" => :sierra
    sha256 "1638ef10eef811a3c9b17d48b0357c4ce92dce8fdb67b1ed0f75d6707f9c6230" => :el_capitan
    sha256 "3b3762fc6c7947684f89c18261b7dd93ab71d756a33d6edbfdb25a75d62a2e79" => :yosemite
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    # Build internal Clang
    mkdir "3rd/templight/build" do
      system "cmake", "../llvm", "-DLIBCLANG_BUILD_STATIC=ON", *std_cmake_args
      system "make", "clang"
      system "make", "libclang"
      system "make", "libclang_static"
      system "make", "templight"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.hpp").write <<-EOS.undent
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    assert_match /const int/, shell_output("cat #{testpath}/test.hpp | #{bin}/metashell -H")
  end
end
