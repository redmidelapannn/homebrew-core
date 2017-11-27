class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.28.tar.gz"
  sha256 "1ff33929f042fa333aed1e8923aa628c3ee9e1eb85512686c55092d1e5a9dfa9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f457c8a931ea64624bbaae2de8ebd65667119e04c59dda85c20f7b8eb621871e" => :high_sierra
    sha256 "67f9f37fbbd454bb7e78842318c9b8dea220b268565f033fee86fb46928387f3" => :sierra
    sha256 "9c7f4a37350a89c0b7163f8bdb46613d04b6ecda94ea1ff6b2bf6f260f6becb3" => :el_capitan
  end

  option "without-external-libs", "Disable external libraries (Flac and Vorbis)"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << "--disable-external-libs" if build.without? "external-libs"

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
