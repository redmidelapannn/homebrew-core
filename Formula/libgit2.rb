class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.24.1.tar.gz"
  sha256 "60198cbb34066b9b5c1613d15c0479f6cd25f4aef42f7ec515cd1cc13a77fede"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "fd7bd73b4819b2b109c9667c5209cf32d5eaebbf963f712f420e12ac5748e474" => :el_capitan
    sha256 "586a8764f90c48a4e7c5e054ed73a36e0845f01604e52cf02490373f7f24c1aa" => :yosemite
    sha256 "e30b7c0ca40c674d8a9c14817c416acbb2196eaa424aadb2872751e4457c779e" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libssh2" => :optional
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
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
