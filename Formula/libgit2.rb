class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.28.1.tar.gz"
  sha256 "0ca11048795b0d6338f2e57717370208c2c97ad66c6d5eac0c97a8827d13936b"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "9dc2bdfa5c5621d806a623f2130eb21acf6a5fb329881a0a0432169c13b8bd0f" => :mojave
    sha256 "7c0dfc04e9f684f7029106d6e876d2abd98a3f856cc37384e2d69d6792217ac6" => :high_sierra
    sha256 "1529e175fcf7cde9d241fae70a9cb35c52bbe401bcb563d2bee3dae0a5b4ded1" => :sierra
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
        (pkgshare/"examples").install "add", "blame", "cat-file", "cgit2",
                                      "describe", "diff", "for-each-ref",
                                      "general", "init", "log", "remote",
                                      "rev-list", "rev-parse", "showindex",
                                      "status", "tag"
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
