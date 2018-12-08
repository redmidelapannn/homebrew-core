class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.10/vifm-0.10.tar.bz2"
  sha256 "e05a699f58279f69467d75d8cd3d6c8d2f62806c467fd558eda45ae9590768b8"

  bottle do
    sha256 "488883e5eacdc6d1075863b27be8e48e8b079c47b658b7fa2eddc23693c3233a" => :mojave
    sha256 "b089816de372ff18e47ab12fbd54a38f5e171262c2df09466e4ba0ed551ab969" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
