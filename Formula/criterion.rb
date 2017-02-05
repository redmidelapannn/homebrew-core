class Criterion < Formula
  desc "Dead-simple, non-intrusive unit testing framework for C and C++"
  homepage "http://criterion.readthedocs.io"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.3.0-1/criterion-v2.3.0-1.tar.bz2"
  version "2.3.0-1"
  sha256 "46a9473b7b35c5ffbb55927f1d9ad0d204dda3a6f0b8fea4003e2490e55619d5"

  bottle do
    cellar :any
    sha256 "ff7c58b76e6f47893bf429344d3f86ebe6008b8e8f82c4387bbe040be5cc583f" => :sierra
    sha256 "a03ed612415c38c40f09a11e205a00bd7300280c598357f018af58e93aae6db4" => :el_capitan
    sha256 "e7e588b23b63162d5c94ac5618bf8d1d4f67e2cefe31c2f60bc662601688ffe1" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
                      "-DCMAKE_INSTALL_PREFIX=#{prefix}", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test_criterion.c").write <<-EOS.undent
      #include <criterion/criterion.h>

      Test(sample, test) {
        cr_assert(1);
      }
    EOS
    system ENV.cc, "test_criterion.c", "-lcriterion", "-o", "test_criterion"
    system "./test_criterion"
  end
end
