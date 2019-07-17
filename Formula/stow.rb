class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftp.gnu.org/gnu/stow/stow-2.3.0.tar.bz2"
  mirror "https://ftpmirror.gnu.org/stow/stow-2.3.0.tar.bz2"
  sha256 "65c7c7eb8ba7ce18b50543bacc5d0a7fc5a886f2be233cf1edca8fcef940d6ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "e27863758aba3b1147d661ef1cf9beccbb252b98e16deee159944e513afebf02" => :mojave
    sha256 "e27863758aba3b1147d661ef1cf9beccbb252b98e16deee159944e513afebf02" => :high_sierra
    sha256 "67eed47537beebcb2356068e9d7ad7bb1dc1fff8028db11e33b3949fbba090ec" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
