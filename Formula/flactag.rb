class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "19edcd3a87001e4b59650382c19bbec88a220266158f66c67d056b8f7ad731fa" => :high_sierra
    sha256 "8718a646ed191d8234b526e2971d5aa4d47d88908c196e4eaa36b1c5333213c5" => :sierra
    sha256 "fd91dc05635b2ff1033b5c3871e5ed0094d6b6da4e27c1efcda78ee8edc42550" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "flac"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "libdiscid"
  depends_on "s-lang"
  depends_on "unac"
  depends_on "jpeg"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ed0e680/flactag/jpeg9.patch"
    sha256 "a8f3dda9e238da70987b042949541f89876009f1adbedac1d6de54435cc1e8d7"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flactag"
  end
end
