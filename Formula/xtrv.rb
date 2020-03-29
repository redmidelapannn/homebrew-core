class Xtrv < Formula
  desc "A simple archiving utility"
  homepage ""
  url "https://github.com/ttshivhula/xtrv/archive/v0.0.3.tar.gz"
  sha256 "f92274fbd719ffd1e43cfe1a1b37fd81d0692fb67cb37b7f131d64cca738a9a1"
  head "https://github.com/ttshivhula/xtrv.git"

  def install
    system "make"
    system "mkdir #{prefix}/bin"
    system "mkdir #{prefix}/share"
    system "cp xtrv #{prefix}/bin/"
    system "cp unxtrv #{prefix}/bin/"
    system "cp -rf man #{prefix}/share"
  end
end
