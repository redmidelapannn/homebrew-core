class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/advancemenu-2.9/advancemenu-2.9.tar.gz"
  sha256 "c7599da6ff715eb3ad9f7a55973a9aaac2f26740a4e12daf744cf08963d652c1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bbedb7e2d47f58d930c05f80d717e508543ec52a43adbecbf2f1342abd564a9d" => :mojave
    sha256 "5ab6fa1063cb20642081d0f8c19d930d7c5ae282cca42938f7417d19fe7b0a67" => :high_sierra
    sha256 "d355171080b6f2885208b7ad336e51167ad6ef3ce7af80dbb8cb9bf3b3e871cc" => :sierra
  end

  depends_on "sdl"
  uses_from_macos "expat"

  conflicts_with "advancemame", :because => "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    system bin/"advmenu", "--version"
  end
end
