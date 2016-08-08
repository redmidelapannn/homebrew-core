class Libmatheval < Formula
  desc "Library to parse and evaluate symbolic expressions input as text."
  homepage "https://www.gnu.org/software/libmatheval/"
  url "https://ftpmirror.gnu.org/libmatheval/libmatheval-1.1.11.tar.gz"
  sha256 "474852d6715ddc3b6969e28de5e1a5fbaff9e8ece6aebb9dc1cc63e9e88e89ab"

  bottle do
    cellar :any
    sha256 "3d407be94a7a9232883fbcb8400ab84b3b2f600f4ab5d23ca1d05c0e35a6b3ed" => :el_capitan
    sha256 "0162d59fc86ed77bdd9f9b73dfc4f7d2b8326511564a1b2946f4cdc805d7f62f" => :yosemite
    sha256 "6c4a81b46f853ada1386ea493f0b7fb99df9b81cba04fd49f5c3f72a6c222ef2" => :mavericks
  end

  depends_on "bdw-gc" => :linked
  depends_on "bison" => :build
  depends_on "guile"

  def install
    # The configure script adds the Guile link directives in the wrong order.
    ENV.append "LDFLAGS", `guile-config link`
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # "tests" depends on deprecated Guile features.
    ["doc", "lib"].each do |dir|
      system "make", "-C", dir, "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <matheval.h>
      #include <stdio.h>

      int main(void) {
        void* evaluator = evaluator_create("x^2");
        printf("%s\\n", evaluator_get_string(evaluator));
        evaluator_destroy(evaluator);
        return 0;
      }
    EOS
    system ENV.cc, "-o", testpath/"test",
           testpath/"test.c", "-L#{lib}", "-lmatheval"
    assert_equal "(x^2)", shell_output("./test").strip
  end
end
