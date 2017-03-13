class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  head "https://git.srcbox.net/gkrellm", :using => :git

  stable do
    url "https://billw2.github.io/gkrellm/gkrellm-2.3.5.tar.bz2"
    sha256 "702b5b0e9c040eb3af8e157453f38dd6f53e1dcd8b1272d20266cda3d4372c8b"

    # https://git.srcbox.net/gkrellm/commit/?id=207a0519ac73290ba65b6e5f7446549a2a66f5d2
    # Resolves a NULL value crash. Fixed upstream already but unreleased in stable.
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/8040a52382/gkrellm/nullpointer.patch"
      sha256 "d005e7ad9b4c46d4930ccb4391481716b72c9a68454b8d8f4dfd2b597bfd77cc"
    end
  end

  bottle do
    rebuild 1
    sha256 "c0af74dc1cf1a45a8ccef0016a2022f4564ea49ac7f26aa5abe58fe5a17791d4" => :sierra
    sha256 "5dcc356c00fcd23d28cd4a1666574bb5cb5d0220540fef77a5a7595775d03d7f" => :el_capitan
    sha256 "5e57d39edd8191e7c01a119b195b209e1507eb8aa255ad4572584a25ee86743d" => :yosemite
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
  depends_on "pango"
  depends_on "gobject-introspection"
  depends_on "openssl"

  def install
    # Fixes broken pkg-config call. Without this compile fails on linking errors.
    # Already fixed upstream but unreleased.
    if build.stable?
      inreplace "src/Makefile", "gtk+-2.0 gthread-2.0", "gtk+-2.0 gthread-2.0 gmodule-2.0"
    end

    system "make", "INSTALLROOT=#{prefix}", "macosx"
    system "make", "INSTALLROOT=#{prefix}", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/gkrellmd --pidfile #{testpath}/test.pid"
    end
    sleep 2

    begin
      assert File.exist?("test.pid")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
