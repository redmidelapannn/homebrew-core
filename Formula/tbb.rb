class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2017_U7.tar.gz"
  version "2017_U7"
  sha256 "78ad6ec9dd492b9dcc4753938b06716f7458506084adc138ced09aa0aa609b6b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "668d67076ef2cac2d13683688a3a776a99e85e09e9b3729654d32f70c5b7f4f8" => :sierra
    sha256 "431818f1a0298f893d922e9d458b060be261b4656397175d50c75be6385a784d" => :el_capitan
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  # Patch clang C++11 support (reported upstream by email)
  patch :DATA

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    args = %W[tbb_build_prefix=BUILDPREFIX compiler=#{compiler}]

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tbb/task_scheduler_init.h>
      #include <iostream>

      int main()
      {
        std::cout << tbb::task_scheduler_init::default_num_threads();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltbb", "-o", "test"
    system "./test"
  end
end

__END__
--- a/include/tbb/tbb_config.h
+++ b/include/tbb/tbb_config.h
@@ -740,7 +740,7 @@

 // The implicit upcasting of the tuple of a reference of a derived class to a base class fails on icc 13.X if the system's gcc environment is 4.8
 // Also in gcc 4.4 standard library the implementation of the tuple<&> conversion (tuple<A&> a = tuple<B&>, B is inherited from A) is broken.
-#if __GXX_EXPERIMENTAL_CXX0X__ && ((__INTEL_COMPILER >=1300 && __INTEL_COMPILER <=1310 && __TBB_GLIBCXX_VERSION>=40700) || (__TBB_GLIBCXX_VERSION < 40500))
+#if __GXX_EXPERIMENTAL_CXX0X__ && !__clang__ && ((__INTEL_COMPILER >=1300 && __INTEL_COMPILER <=1310 && __TBB_GLIBCXX_VERSION>=40700) || (__TBB_GLIBCXX_VERSION < 40500))
 #define __TBB_UPCAST_OF_TUPLE_OF_REF_BROKEN 1
 #endif
