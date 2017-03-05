class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opus-1.1.4.tar.gz"
  sha256 "9122b6b380081dd2665189f97bfd777f04f92dc3ab6698eea1dbb27ad59d8692"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66b09a0f9ba20bbd2557b9f4f026d2d75161f535812dbc1a39b131dbdc969737" => :sierra
    sha256 "c6c9e62d320c2f534a31e917120210a8043be724f66b8bc30448dd8a8bcd1e5d" => :el_capitan
    sha256 "d1ba7131849a37802b69ee7a6ef32e445557159dc803ed4ea61dc43fee31f98a" => :yosemite
  end

  head do
    url "https://git.xiph.org/opus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-custom-modes", "Enable custom-modes for opus see https://www.opus-codec.org/docs/opus_api-1.1.3/group__opus__custom.html"

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
