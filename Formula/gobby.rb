class Gobby < Formula
  desc "Multi-platform collaborative text editor"
  homepage "https://gobby.github.io/"
  url "http://releases.0x539.de/gobby/gobby-0.5.0.tar.gz"
  sha256 "8ceb3598d27cfccdf9c9889b781c4c5c8e1731ca6beb183f5d4555644c06bd98"
  revision 7
  head "https://github.com/gobby/gobby"

  bottle do
    rebuild 1
    sha256 "e395730293bcb5b904f3f440f4aeb09e8839181dd6b8879d2c49c324ff9c2c76" => :catalina
    sha256 "1c65c4598d7701eb591712988c421ae9580b503d49c537585b939712979afe05" => :mojave
    sha256 "b7c791059e09cd2246524fc12fd71f1172a7f06abbd4a03bf58969b59d91e09c" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "gtkmm3"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "libinfinity"
  depends_on "libxml++"

  # Necessary to remove mandatory gtk-mac-integration
  # it's badly broken as it depends on an ancient version of ige-mac-integration
  # since it depends on gtk3, it doesn't even need gtk-mac-integration anymore
  # This has already been fixed upstream: gtk2 support has been dropped completely
  # and all traces of ige-mac-integration have been removed from the code
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gobby/0.5.0.patch"
    sha256 "d406603caae0a2ed6e01ec682fdd0ba5b3b23c5a731082f93b2500c95ab2f7e6"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-gtk3"
    system "make", "install"
  end

  test do
    # executable (GUI)
    system bin/"gobby-0.5", "--version"
  end
end
