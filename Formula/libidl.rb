class Libidl < Formula
  desc "Library for creating CORBA IDL files"
  homepage "https://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/"
  url "https://download.gnome.org/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2"
  sha256 "c5d24d8c096546353fbc7cedf208392d5a02afe9d56ebcc1cccb258d7c4d2220"

  bottle do
    cellar :any
    rebuild 2
    sha256 "e9ae2e40f694ceaa59a26972a768d693ea14b69dbf1bc0664f4442112644000a" => :sierra
    sha256 "a0a0b219d9164c5697a0b82064985ff4f1461bd5435d298d939c245db0b8f945" => :el_capitan
    sha256 "b71feb3806dbacbbaa288114a77f7521521ef3383b1de858351f50a307a7db3f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
