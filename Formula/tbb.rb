class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb2017_20161004oss_src.tgz"
  version "4.4-20161004"
  sha256 "f4ba7a7ed1bcb6c05d47e73624ca2e4580104bc0d3e0a3ccc7b67fa324760cb1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "21680b1a222e9cdf58dd2178f879454a3aab601ce9079f3161186c66ed601e94" => :sierra
    sha256 "7bee489598e95f4066c916fe6c826c41c9c960c142031790043ddd1143fa6c34" => :el_capitan
    sha256 "d81765560316b719120c257cd9279fcbf6caa2f534bd1dc683985f43e7783521" => :yosemite
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  def install
    compiler = ENV.compiler == :clang ? "clang" : "gcc"
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
    system ENV.cxx, "test.cpp", "-ltbb", "-o", "test"
    system "./test"
  end
end
