class Gdmap < Formula
  desc "Tool to inspect the used space of folders"
  homepage "https://sourceforge.net/projects/gdmap/"
  url "https://downloads.sourceforge.net/project/gdmap/gdmap/0.8.1/gdmap-0.8.1.tar.gz"
  sha256 "a200c98004b349443f853bf611e49941403fce46f2335850913f85c710a2285b"
  revision 2

  bottle do
    rebuild 1
    sha256 "552e28a0f4395aff3336b9015e9ccf553dc046eef1ac60b9df399e867d545c7f" => :catalina
    sha256 "81848118c5dcf5894a99f90026bb610143e8b11105dfe404dce7c60a5154c9aa" => :mojave
    sha256 "05e5ab5f969f07b5af33db43dc6952bbab137a64f718f895eff7e9d304807718" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"

  # The code depends on some GTK macros that are flagged as deprecated in the brew version of GTK.
  # I assume they're not deprecated in normal GTK, because the config file disables deprecated GDK calls.
  # The first patch turns off this disablement, making the code work fine as intended
  # The second patch is to remove an unused system header import on one of the files.
  # This header file doesn't exist in OSX and the program compiles and runs fine without it.
  # Filed bug upstream as https://sourceforge.net/p/gdmap/bugs/19/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gdmap/0.8.1.patch"
    sha256 "292cc974405f0a8c7f6dc32770f81057e67eac6e4fcb1fc575e1f02e044cf9c3"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/gdmap", "--help"
  end
end
