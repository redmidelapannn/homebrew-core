class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.03.tar.bz2"
  sha256 "e0959f21e54e7f4700042a3a14987a7f8fc898701eab4f721ebcf4559a2c87b5"
  revision 1

  bottle do
    rebuild 1
    sha256 "26769ce683580ea27e7990efbb03d4fae6c59eaa06d2fc5be0bec19d89bb9fd2" => :high_sierra
    sha256 "db8d262996aa286650fc02e054a6a57f6c1a44c392549c70347bbed3a83290d7" => :sierra
    sha256 "4ff22d725097816747306d0484d76ffd9108c7ef5bdf83fd83b08264f3b9458b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
