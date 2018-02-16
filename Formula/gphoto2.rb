class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.15/gphoto2-2.5.15.tar.bz2"
  sha256 "ae571a227983dc9997876702a73af5431d41f287ea0f483cda897c57a6084a77"

  bottle do
    cellar :any
    rebuild 1
    sha256 "be3492e514d4b4197836a402e2d20ac6e4197d88ecf48f082838c72eea814207" => :high_sierra
    sha256 "0ec7c2f0ad7a9c79454e5fbd77da63b95059809bff0c49dad784f36bfc91d76e" => :sierra
    sha256 "c41258cf4ed5d30278d4cc8814d4def7a238a0121592650ae4be18e362307c40" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
