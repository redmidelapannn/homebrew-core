class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018_U3.tar.gz"
  version "2018_U3"
  sha256 "23793c8645480148e9559df96b386b780f92194c80120acce79fcdaae0d81f45"
  revision 1

  bottle do
    rebuild 1
    sha256 "06a51e155d281703e799d2e61609682815cb7579b0fc867c8811cd36799e3575" => :high_sierra
    sha256 "087f78b7a86f4082dd3abaa7f199f42aedb92da2ccafda52e3ea7f952be91940" => :sierra
    sha256 "59ac3d226bc3d0499a1f7e4238669656677e36b435b0aa217b644cbff839b396" => :el_capitan
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on "python@2"
  depends_on "swig" => :build

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    args = %W[tbb_build_prefix=BUILDPREFIX compiler=#{compiler}]

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python", *Language::Python.setup_install_args(prefix)
    end
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
