class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.7.0.tar.gz"
  sha256 "b3cea010b3e36dabc7603ebcbb9b300f32f441d14aa8630584e06e70abb08fd2"

  bottle do
    cellar :any
    sha256 "aed0e78a3ddbbfec8ed6971747758b7452c854e867bef596e3df186b735a1e49" => :catalina
    sha256 "59c6edeea7a650276cde0087612a4ffb7f11b916382016d1afa43ddbf7c9b385" => :mojave
    sha256 "ef867e4e0328712cd66cc366a1bf400b6327ef4c5f382068f4eeee9efdb4a880" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cglm/cglm.h>
      #include <assert.h>

      int main() {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f},
             z = {0.0f, 0.0f, 1.0f};
        vec3 r;

        glm_cross(x, y, r);
        assert(glm_vec3_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
