class Sc68 < Formula
  desc "Play music originally designed for Atari ST and Amiga computers"
  homepage "http://sc68.atari.org/project.html"
  url "https://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz"
  sha256 "d7371f0f406dc925debf50f64df1f0700e1d29a8502bb170883fc41cc733265f"

  bottle do
    rebuild 1
    sha256 "3663155d233591fe01414b3e8c19b7bed8065bded4fa9f7f601b15d714be2150" => :sierra
    sha256 "d68152fca5767f9e7fb4a689d36d6c73786cbfae301cc6ed926cb6022ccfdb92" => :el_capitan
    sha256 "4b8aa08c152ee5aef8345c7e9ba707bafbb0758fda07b8efbf9dfec88a9f703b" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    # SC68 ships with a sample module; test attempts to print its metadata
    system "#{bin}/info68", "#{pkgshare}/Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
