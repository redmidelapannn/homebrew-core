class G3log < Formula
  desc 'asynchronous, "crash safe", logger that is easy to use.'
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.2.tar.gz"
  sha256 "6fd73ac5d07356b3acdde73ad06f2f40cfc1de11b1864a17375c1177b557c1be"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e18686e083f5ae0ee1e6eb955bc5592f6e7457e50dc10a98b1cbbc8c351c4bcb" => :sierra
    sha256 "e69784dc0ad90f3febbaf7959b53b6cfc6c7c52adf64b501275f4b88843605c9" => :el_capitan
    sha256 "07e68f4e7de7822d25879902da9a09833326ba346e13c5cec0e6740aed2deb63" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    # No install target yet: https://github.com/KjellKod/g3log/issues/49
    include.install "src/g3log"
    lib.install "libg3logger.a", "libg3logger.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libg3logger.dylib", "#{lib}/libg3logger.dylib")
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent.gsub(/TESTDIR/, testpath)
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        using namespace g3;
        auto worker = LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "TESTDIR");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lg3logger", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
