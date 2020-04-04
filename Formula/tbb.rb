class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/intel/tbb/archive/v2020.2.tar.gz"
  version "2020_U2"
  sha256 "4804320e1e6cbe3a5421997b52199e3c1a3829b2ecb6489641da4b8e32faf500"

  bottle do
    cellar :any
    sha256 "c2172fa56e54346412d52a580e4156ac97ba63dffe78c531e8bf7de26d280513" => :catalina
    sha256 "e4468dbcf7c1fddc5c091450ed94c5e9a0f003d1e1882bed62d5b12f47a9321c" => :mojave
    sha256 "960dce064bdacea5e685c84b1721ab15733599eceea8edd94338e40c4f14d8b8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python"

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}"
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]

    # Build and install static libraries
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}",
                   "extra_inc=big_iron.inc"
    lib.install Dir["build/BUILDPREFIX_release/*.a"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", *std_cmake_args,
                    "-DINSTALL_DIR=lib/cmake/TBB",
                    "-DSYSTEM_NAME=Darwin",
                    "-DTBB_VERSION_FILE=#{include}/tbb/tbb_stddef.h",
                    "-P", "cmake/tbb_config_installer.cmake"

    (lib/"cmake"/"TBB").install Dir["lib/cmake/TBB/*.cmake"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
