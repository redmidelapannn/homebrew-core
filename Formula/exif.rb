class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "http://libexif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libexif/exif/0.6.21/exif-0.6.21.tar.gz"
  sha256 "1e2e40e5d919edfb23717308eb5aeb5a11337741e6455c049852128a42288e6d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ae8645e99466b553e7198556a2d331759c9f173956dc0c10f584903030c78876" => :sierra
    sha256 "7b3e7722476afc4a0e62fa5107c15da2652a48089d6deeeb0297d7000bef17e1" => :el_capitan
    sha256 "9a71fc4b9c85e72ef1b5936fd946ff92251bf97006753cdad00a0c81177952e8" => :yosemite
  end

  option "with-gettext", "Build with Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "popt"
  depends_on "libexif"
  depends_on "gettext" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--disable-nls" if build.without? "gettext"

    system "./configure", *args
    system "make", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "The data supplied does not seem to contain EXIF data.",
                 shell_output("#{bin}/exif #{test_image} 2>&1", 1)
  end
end
