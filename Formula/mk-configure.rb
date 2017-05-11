class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "http://sourceforge.net/projects/mk-configure/"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.29.1/mk-configure-0.29.1.tar.gz"
  sha256 "a675c532f6a857c79dedef2cce4776dda8becfbe7d2126e5f67175aee56c3957"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f11dd4d85e917c7e755fb97ce6524a229fdee6e999d20ab8785e7422de8384b" => :sierra
    sha256 "c9b48064e161d9e2922792057153309789e3a87008ea3895b0d7c9e1142cea67" => :el_capitan
    sha256 "c9b48064e161d9e2922792057153309789e3a87008ea3895b0d7c9e1142cea67" => :yosemite
  end

  depends_on "bmake" => :build
  depends_on "makedepend" => :build
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = "#{prefix}"
    ENV["MANDIR"] = "#{man}"

    system "bmake", "all"
    system "bmake", "install"
    cp "presentation/presentation.pdf", "#{share}/doc/mk-configure/"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
