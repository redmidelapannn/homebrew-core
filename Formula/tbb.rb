class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2017_U7.tar.gz"
  version "2017_U7"
  sha256 "755b7dfaf018f5d8ae3bf2e8cfa0fa4672372548e8cc043ed1eb5b22a9bf5b72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aa42441ddc1fffbe4ad711392227783a22b116c861d77ad0991b025437d77318" => :sierra
    sha256 "10cf9261190840d798a191f8d5de1908585db2a66150286502c508c2c9a87f6d" => :el_capitan
    sha256 "f65af9e4322196e6a0edc7d18f6323ef1bba78399a85d19eb096d3993331e26c" => :yosemite
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

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
