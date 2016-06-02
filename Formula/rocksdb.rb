class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/v4.6.1.tar.gz"
  sha256 "b6cf3d99b552fb5daae4710952640810d3d810aa677821a9c7166a870669c572"

  bottle do
    cellar :any
    sha256 "4ef4cc991d627f4339240c8786ce334952122d1d2453f89d3d44502362c8184a" => :el_capitan
    sha256 "15bca62cffd3794aa5f20e6dae45d043b97c0d24867cd7d2e48a1a4a1848096e" => :yosemite
    sha256 "5d692c7758a162efc74d9c288d479b0d28cc672074655bb24a5b8c80f7987f5e" => :mavericks
  end

  option "with-lite", "Build mobile/non-flash optimized lite version"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    ENV.append_to_cflags "-DROCKSDB_LITE=1" if build.with? "lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        options.memtable_factory.reset(
                    NewHashSkipListRepFactory(16));
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v", "-std=c++11",
                                "-stdlib=libc++",
                                "-lstdc++",
                                "-lrocksdb",
                                "-lz", "-lbz2",
                                "-lsnappy", "-llz4"
    system "./db_test"
  end
end
