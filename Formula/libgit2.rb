class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.26.0.tar.gz"
  sha256 "6a62393e0ceb37d02fe0d5707713f504e7acac9006ef33da1e88960bd78b6eac"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    rebuild 1
    sha256 "b4c18a694785217306465c2c1c5d2e34cc5e1a7bd64ad87836ca5c0b5981918f" => :high_sierra
    sha256 "5e6153efd6c6db3eca832d2210542b16c8c1033e015a79145923eacec6aa28a1" => :sierra
    sha256 "64a18698cdf966bb243eb323626a9c13b2b180f7aeaf427bfe0231309b596426" => :el_capitan
  end

  devel do
    url "https://github.com/libgit2/libgit2/archive/v0.27.0-rc2.tar.gz"
    sha256 "7ba5b1155f3a35da63654f29465ab7e39e616a039b05bd639e38194e9c2784be"
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libssh2" => :recommended
  depends_on "openssl" if MacOS.version <= :lion # Uses SecureTransport on >10.7

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.
    args << "-DUSE_SSH=NO" if build.without? "libssh2"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "add", "blame", "cat-file", "cgit2",
                                      "describe", "diff", "for-each-ref",
                                      "general", "init", "log", "remote",
                                      "rev-list", "rev-parse", "showindex",
                                      "status", "tag"
      end
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
