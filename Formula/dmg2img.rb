class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  bottle do
    cellar :any
    sha256 "b802f561770242111f3fe302376a6ee57a7205575e62083ed7b15e733cecb9be" => :mojave
    sha256 "a5f5a549bf0fffe7248b610c963d4b881e7af339f011e61d098ec67376c13351" => :high_sierra
    sha256 "c1ce2a5860f4bb6e2882547d63b336b94605f97e9d61cf013b7f273a857ab1d6" => :sierra
  end

  depends_on "openssl"

  def install
    ENV["CFLAGS"]=ENV["CXXFLAGS"]="-L/usr/local/opt/openssl/lib -I/usr/local/opt/openssl/include"
    ENV["DESTDIR"]=bin.to_s
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
