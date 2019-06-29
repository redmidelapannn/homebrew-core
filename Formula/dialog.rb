class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20190211.tgz"
  sha256 "49c0e289d77dcd7806f67056c54f36a96826a9b73a53fb0ffda1ffa6f25ea0d3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "092ee1f2c3006e7a988460577b7dd91d6ef9806c7ac642df433e5b041e6a997e" => :mojave
    sha256 "7fc3dd67a32b6c8f3c2edd0fa04172339c374e2a773138f1c2386f6d1a26b0e2" => :high_sierra
    sha256 "5b17be7aefcfd4bab10a8fe4effd488b9b9fd1662c5c52de429468cff2f375cf" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
