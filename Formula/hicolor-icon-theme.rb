class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz"
  sha256 "9cc45ac3318c31212ea2d8cb99e64020732393ee7630fa6c1810af5f987033cc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7f92f7ed1133cda6714939bee1d0e61dd4fc9f8c5818e885ec2433bcd04baf0" => :sierra
    sha256 "e7f92f7ed1133cda6714939bee1d0e61dd4fc9f8c5818e885ec2433bcd04baf0" => :el_capitan
    sha256 "e7f92f7ed1133cda6714939bee1d0e61dd4fc9f8c5818e885ec2433bcd04baf0" => :yosemite
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
    File.exist? share/"icons/hicolor/index.theme"
  end
end
