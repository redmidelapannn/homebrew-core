class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"
  revision 1

  head "https://github.com/zmap/zmap.git"

  bottle do
    sha256 "e5570a037295b71c02fe5f962f486792aa0f039a465c1e983b23008824981905" => :high_sierra
    sha256 "73d96887918b44cbdde59f515517b7fef9feba0bf364c9da8b586a10a2f1046c" => :sierra
    sha256 "4d6088e86126790b05c0f92b93454fe861892ffde34fe64b2e36678c03549df2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "byacc" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libdnet"
  depends_on "json-c"
  depends_on "hiredis" => :optional
  depends_on "mongo-c-driver" => :optional

  deprecated_option "with-mongo-c" => "with-mongo-c-driver"

  def install
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in"], "/etc", etc

    args = std_cmake_args
    args << "-DENABLE_DEVELOPMENT=OFF"
    args << "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    args << "-DWITH_REDIS=ON" if build.with? "hiredis"
    args << "-DWITH_MONGO=ON" if build.with? "mongo-c-driver"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
    assert_match /redis-csv/, `#{sbin}/zmap --list-output-modules` if build.with? "hiredis"
    assert_match /mongo/, `#{sbin}/zmap --list-output-modules` if build.with? "mongo-c-driver"
  end
end
