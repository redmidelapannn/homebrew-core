class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.5.tar.gz"
  sha256 "dc0cb611fa087b14806850f9c8cf7a50d592faee7c839ec9d5221d14e48b269c"

  bottle do
    sha256 "2bd43af912830541db930fd45526a78d7a60c011b87235398e8978a2dcbce3fa" => :mojave
    sha256 "474cec7ea507b67a8cfe83175b4ec55f34976697add18b62e7dd1b3757e456ee" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
