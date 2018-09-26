class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.20.tar.gz"
  sha256 "f5abe8b5b209c2f36560b75f32ce61412f39a2922f7045ae764a2c23335b6664"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "4fb931dd9586773708b269ea5960e97e4e4a04d3eecfb46519ee5e73ac9b9ba2" => :mojave
    sha256 "3f6ac6867012aab0db6a4185382ac0b6033c012f9b1ba5ba08574636cbf0a2af" => :high_sierra
    sha256 "624ea0f574422ae51fd8a73b6f82b5161b41684453026ecec7038a2f98fa95c4" => :sierra
  end

  depends_on "gperftools"
  depends_on "snappy"

  def install
    system "make"
    system "make", "check" if build.bottle?

    include.install "include/leveldb"
    bin.install "out-static/leveldbutil"
    lib.install "out-static/libleveldb.a"
    lib.install "out-shared/libleveldb.dylib.1.20" => "libleveldb.1.20.dylib"
    lib.install_symlink lib/"libleveldb.1.20.dylib" => "libleveldb.dylib"
    lib.install_symlink lib/"libleveldb.1.20.dylib" => "libleveldb.1.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.20.dylib")
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
