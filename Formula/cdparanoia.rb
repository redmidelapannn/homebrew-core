class Cdparanoia < Formula
  desc "Audio extraction tool for sampling CDs"
  homepage "https://www.xiph.org/paranoia/"
  url "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz"
  sha256 "005db45ef4ee017f5c32ec124f913a0546e77014266c6a1c50df902a55fe64df"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d2e949ebb9d96a273cb666cc0badc76028d288c653ab4567c160961754e2e8ed" => :sierra
    sha256 "f3adbca1721d1e0aac96a656390af6a10d9ef85aa65e4657f0cd43b21dd48062" => :el_capitan
    sha256 "60e39e4a6d080f867db42331584d861accada527540c51d9ee970fcf59fd9a4e" => :yosemite
  end

  depends_on "autoconf" => :build

  # Patches via MacPorts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2a22152/cdparanoia/osx_interface.patch"
    sha256 "3eca8ff34d2617c460056f97457b5ac62db1983517525e5c73886a2dea9f06d9"
  end

  def install
    system "autoconf"
    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--libdir=#{libexec}"
    system "make", "all"
    system "make", "install"
  end
end
