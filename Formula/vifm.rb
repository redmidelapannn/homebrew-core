class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.8.1a.tar.bz2"
  mirror "https://github.com/vifm/vifm/releases/download/v0.8.1a/vifm-0.8.1a.tar.bz2"
  sha256 "974fb2aa5e32d2c729ceff678c595070c701bd30a6ccc5cb6ca64807a9dd4422"

  bottle do
    revision 1
    sha256 "502bc9829557fa39926757d17404d4e15d9be9547cadaa8abe79e18294dc043c" => :el_capitan
    sha256 "da8f751c619e4a4b934a1234f68480b29e1c437adde000d75cd3a23a322ee67b" => :yosemite
    sha256 "7ae5990f38c2f0a4a4334514236bae3775e711bc0887f9303f34f22b62a55dd8" => :mavericks
  end

  head do
    url "https://github.com/vifm/vifm.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-ivf" if build.head?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    system "./configure", *args

    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /^Version: #{Regexp.escape(version)}/,
      shell_output("#{bin}/vifm --version")
  end
end
