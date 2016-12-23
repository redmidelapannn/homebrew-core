class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.24.5.tar.gz"
  sha256 "f6135ee64b174f449c8857272352c11ca182af05a340237834cedcc9eb390cba"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    rebuild 1
    sha256 "3b2cd18006c997c7f3b19f1aafb641413b2186acd90b5ade20051b69e1890da8" => :sierra
    sha256 "e0ea2bbccb06f87344beaad6df5b4d0be83dee1b2c0a54a51a6be661fc04eb5f" => :el_capitan
    sha256 "c5e1c9c89d3ece9ea3ce55c7533c9f19120525759eac87e1da10fb36574377b0" => :yosemite
  end

  devel do
    url "https://github.com/libgit2/libgit2/archive/v0.25.0-rc2.tar.gz"
    version "0.25.0-rc2"
    sha256 "4bb27401ec30349690a7e2c937d497c7d32b2fc3ba75a4e8f71b38a6d2e15eb9"
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libssh2" => :recommended
  depends_on "openssl" if MacOS.version <= :lion # Uses SecureTransport on >10.7

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.
    args << "-DUSE_SSH=NO" if build.without? "libssh2"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

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
    (testpath/"test.c").write <<-EOS.undent
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
