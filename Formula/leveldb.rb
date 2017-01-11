class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.19.tar.gz"
  sha256 "7d7a14ae825e66aabeb156c1c3fae9f9a76d640ef6b40ede74cc73da937e5202"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f602a9351c6d648bade9433b4d80df018aca67917a0a19af664015f29ea7ea0b" => :sierra
    sha256 "33d48d723b4237e603e236f5a993654d5ce129a0724f75191b0a05c18843ee9e" => :el_capitan
    sha256 "438ac672014af345f6c98a1f5d552d84587f43043b905cdae1a3529e7eb44a0b" => :yosemite
  end

  option "with-test", "Verify the build with make check"

  depends_on "gperftools"
  depends_on "snappy"

  def install
    system "make"
    system "make", "check" if build.bottle? || build.with?("test")

    include.install "include/leveldb"
    bin.install "out-static/leveldbutil"
    lib.install "out-static/libleveldb.a"
    lib.install "out-shared/libleveldb.dylib.1.19" => "libleveldb.1.19.dylib"
    lib.install_symlink lib/"libleveldb.1.19.dylib" => "libleveldb.dylib"
    lib.install_symlink lib/"libleveldb.1.19.dylib" => "libleveldb.1.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.19.dylib")
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
