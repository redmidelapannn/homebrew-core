class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.0.0.tar.gz"
  sha256 "6a1fa16a7f6335ce8b2630fbdbb5e57c4027929ebc56fcd1ac55edb141b409b4"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "4ed87680dc95e9155b2bf5aec6d7ca9200bfe26998b02adab13338e3a28061ae" => :catalina
    sha256 "411ac855fcfb5ecb739f209f9121abca8b8c1c8faf59f4ef23206e45f59b4b08" => :mojave
    sha256 "6641d0e6bf1d80fb5c24410693e97ccbe2af68651a3471d19b7fa1f87daad7a0" => :high_sierra
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
