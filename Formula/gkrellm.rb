class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.10.tar.bz2"
  sha256 "8b9ec8baadcd5830c6aff04ba86dc9ed317a15c1c3787440bd1e680fb2fcd766"
  revision 1

  bottle do
    rebuild 1
    sha256 "0386afe145b5dcf97248f68b165ac1b59db771cd4025ca128ac2fe4cbe3feab2" => :mojave
    sha256 "f46e2ca6d972c00261d547c27585219025be55e1b8f5c0e23268cb10b4a45ba0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "openssl"
  depends_on "pango"

  def install
    system "make", "INSTALLROOT=#{prefix}", "macosx"
    system "make", "INSTALLROOT=#{prefix}", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/gkrellmd --pidfile #{testpath}/test.pid"
    end
    sleep 2

    begin
      assert_predicate testpath/"test.pid", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
