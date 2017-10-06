class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz"
  sha256 "317484352271d18cbbcfac3868eab798d67fff1b8402e740baa6ff41d588a9d8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7c33f3c3a7397085c708c07176d78a10346ba927ce74bec75aaea1f219bce926" => :high_sierra
    sha256 "7c33f3c3a7397085c708c07176d78a10346ba927ce74bec75aaea1f219bce926" => :sierra
    sha256 "7c33f3c3a7397085c708c07176d78a10346ba927ce74bec75aaea1f219bce926" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    assert_predicate share/"icons/hicolor/index.theme", :exist?
  end
end
