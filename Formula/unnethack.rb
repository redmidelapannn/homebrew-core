class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://sourceforge.net/projects/unnethack/"
  url "https://downloads.sourceforge.net/project/unnethack/unnethack/5.1.0/unnethack-5.1.0-20131208.tar.gz"
  sha256 "d92886a02fd8f5a427d1acf628e12ee03852fdebd3af0e7d0d1279dc41c75762"

  head "https://github.com/UnNetHack/UnNetHack.git"

  bottle do
    rebuild 1
    sha256 "21fbec384abbbbc8550dc9a113ef2d6a3a71a6ec8874e23906f9fa8ad89efd20" => :high_sierra
    sha256 "2c18c2708085c87121c05cdd3ef3eb653f327cd3ba7476b78f9208aa87dcbe7e" => :sierra
    sha256 "1d3bf8f45464aaae791a3bdc840e745a7ee5cf868e7d3851f89817ed3656e869" => :el_capitan
  end

  # directory for temporary level data of running games
  skip_clean "var/unnethack/level"

  option "with-lisp-graphics", "Enable lisp graphics (play in Emacs)"
  option "with-curses-graphics", "Enable curses graphics (play with fanciness)"

  def install
    # directory for version specific files that shouldn't be deleted when
    # upgrading/uninstalling
    version_specific_directory = "#{var}/unnethack/#{version}"

    args = [
      "--prefix=#{prefix}",
      "--with-owner=#{`id -un`}",
      "--with-group=admin",
      # common xlogfile for all versions
      "--enable-xlogfile=#{var}/unnethack/xlogfile",
      "--with-bonesdir=#{version_specific_directory}/bones",
      "--with-savesdir=#{version_specific_directory}/saves",
      "--enable-wizmode=#{`id -un`}",
    ]

    args << "--enable-lisp-graphics" if build.with? "lisp-graphics"
    args << "--enable-curses-graphics" if build.with? "curses-graphics"

    system "./configure", *args
    ENV.deparallelize # Race condition in make

    # disable the `chgrp` calls
    system "make", "install", "CHGRP=#"
  end
end
