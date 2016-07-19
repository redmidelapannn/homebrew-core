class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20160128oss_src_0.tgz"
  version "4.4-20160128"
  sha256 "8d256bf13aef1b0726483af9f955918f04e3de4ebbf6908aa1b0c94cbe784ad7"

  bottle do
    cellar :any
    revision 1
    sha256 "df97c6344d59256ada5ecf2a95561dbc624ab4fd2a01f996546297dc7aeeb39d" => :el_capitan
    sha256 "46c3ade56d48aea89a64181160c0219532f18158b91c86408d39883636f85a64" => :yosemite
    sha256 "b09868b722349377571c215d11876373a6a1a8c311e056ae394884d1c711445f" => :mavericks
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization

    args = %W[tbb_build_prefix=BUILDPREFIX]

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"
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
