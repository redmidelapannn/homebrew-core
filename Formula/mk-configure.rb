class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.29.1/mk-configure-0.29.1.tar.gz"
  sha256 "a675c532f6a857c79dedef2cce4776dda8becfbe7d2126e5f67175aee56c3957"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cb138c8265315461926a405a35ac28d13c82993073934e8357250660694da89" => :sierra
    sha256 "8182a51dbf0ef7dd1d5d06597d8c3c3268077f4701d1e1bb55c3c270de925f51" => :el_capitan
    sha256 "8182a51dbf0ef7dd1d5d06597d8c3c3268077f4701d1e1bb55c3c270de925f51" => :yosemite
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix.to_s
    ENV["MANDIR"] = man.to_s

    system "bmake", "all"
    system "bmake", "install"
    (share/"doc/mk-configure").install("presentation/presentation.pdf")
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
