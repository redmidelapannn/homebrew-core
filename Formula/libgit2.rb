class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.99.0.tar.gz"
  sha256 "174024310c1563097a6613a0d3f7539d11a9a86517cd67ce533849065de08a11"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "87e6974b3a960f25b05f03f3e5d8e4cdbb280d637c98a9125d70f697e7668284" => :catalina
    sha256 "50a790265b670987229ef99b4519926631f2faf6350f65fb0eaa8f19a8b40643" => :mojave
    sha256 "709376382fec08680fae85ba1751ad8a2beb677a1cd24653636a242a3a228056" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
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
