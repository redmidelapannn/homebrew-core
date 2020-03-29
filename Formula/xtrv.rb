class Xtrv < Formula
  desc "A simple archiving utility"
  bottle do
    cellar :any_skip_relocation
    sha256 "1f531ad99712364a09c9efe911f15f86b58cd69ff3c066e41eeaa650b0f19153" => :catalina
    sha256 "151b05dad1ff641f405ad30b525d11390778c7e0238a523f76e43c9c5b88bb40" => :mojave
    sha256 "ac681a00c75b9eac4a08885cf3641fd619fc2ed7fbab3a1efb9109448397eb7c" => :high_sierra
  end

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
