class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.24.1.tar.gz"
  sha256 "60198cbb34066b9b5c1613d15c0479f6cd25f4aef42f7ec515cd1cc13a77fede"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "61d7bf4359f3de474f356b4c5828ffdc1cf4da836568ca7feea96b27ef747221" => :el_capitan
    sha256 "09230aeb224e44f44225beb23da228bfba947f18617bdd9bd5af25a79c75500c" => :yosemite
    sha256 "979080915156361010eaf646eb4118f9ec0a572e0a0ec35eb4fb65979fcc902c" => :mavericks
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
