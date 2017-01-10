class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.10.2.tar.gz"
  sha256 "2d740a2adea0f1a19058626f55a076ac41a4ac1f95d4e57cae0c8a634a6cd63b"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "231e9a5d5c811ae1344e5a3a8c2133a95ab1157958e310de642aa12f88eee258" => :sierra
    sha256 "4506fdd5991a62d6ef173fbc71d2a11eab8bf36583859a9591d0af50054e5f2a" => :el_capitan
    sha256 "fa2303ec96cf7884b061dbef7b3fd79f3b80493237db6470e42d1ee8f3d25ff6" => :yosemite
  end

  option "without-docs", "Don't build and install documentation"
  option "with-test", "Execute compile time checks (Requires Internet connection)"
  option :universal

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    ENV.universal_binary if build.universal?

    if build.with? "docs"
      # This isn't yet handled by the make install process sadly.
      cd "docs" do
        system "make", "man"
        system "make", "singlehtml"
        man1.install "build/man/libuv.1"
        doc.install Dir["build/singlehtml/*"]
      end
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-luv", "-o", "test"
    system "./test"
  end
end
