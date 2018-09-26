class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.0.0.tar.gz"
  sha256 "f2bdebff62a2fc0b974b309da7be4959869fb7cababe1169b7693cfd672c2fe0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93f6f69d3f1b7cbaf2b7e829bcc1f54f27808a9bc3dbef8d861eaf0169c796c9" => :mojave
    sha256 "8231c5d9a45fd96720dc54713a6a5bd4332bc09201a41f49c277fb00a3980298" => :high_sierra
    sha256 "e1d5109213ea9d04bf32e254a28899d8a1780a9fbcace7587d124eeeb1f888fc" => :sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "ragel" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_STATIC_AND_SHARED=on"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
