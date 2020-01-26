class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.45.0.tar.gz"
  sha256 "a2c9111defa20ae51af16fab86de7c5bb4fb66483e7b94173927b83814d21ad2"

  bottle do
    sha256 "8468cbd03e80bc54c02f8a61ddc1f22c67b51a341036d0cb87b6ca3eda5d05e2" => :catalina
    sha256 "463da1d628e9a8c8e3af2b9ccd4bc4256a1fa8d1d63840e84b0a19996a564e26" => :mojave
    sha256 "954acec6d43750d8dc364dcc64ea48766db0c15cbe504542bce012be5200b396" => :high_sierra
  end

  depends_on :xcode => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qt"
  depends_on "zeromq"

  def install
    # TODO: Remove this when released archive includes
    # the fix of https://github.com/sciapp/gr/pull/101 .
    ENV.deparallelize
    system "make", "GRDIR=#{prefix}"
    system "make", "GRDIR=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end
