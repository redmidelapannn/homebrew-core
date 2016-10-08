class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.88.tar.gz"
  sha256 "4585d2e683d7f68eb8fcb15504732d71d7ede48ab5963e61915201f9e68305be"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f8514a36aabcbd0ae10d6d4325a3fce96bb5f0a12b7c48187d3017d810aff795" => :sierra
    sha256 "e48e7a2618b457ca9d851ee82542a3582db900f9bad239c0639230d4eaa6ba18" => :el_capitan
    sha256 "326bb9d425e757ea4bf95701fab07556197612a928dd5f81b91edb4bf47acfd2" => :yosemite
  end

  head do
    url "https://github.com/kohler/gifsicle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-x11", "Install gifview"

  depends_on :x11 => :optional

  conflicts_with "giflossy",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
