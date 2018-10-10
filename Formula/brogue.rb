class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  # The OS X version doesn't contain a Makefile, so we
  # need to download the Linux version
  url "https://sites.google.com/site/broguegame/brogue-1.7.5-linux-amd64.tbz2"
  version "1.7.5"
  sha256 "a74ff18139564c597d047cfb167f74ab1963dd8608b6fb2e034e7635d6170444"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f6d023201e095ac198e08b069abaee68715f81e0540c5fdd17bdc04a8c7e0178" => :mojave
    sha256 "15ae767cca7777781ec2a6d89e63ffc1822b1ab982ea966e1082d625ed5172ca" => :high_sierra
    sha256 "7843893c8f71ec2824a571324ada4818a24b9d0cdf3ee896a2fe986c2eb3d96e" => :sierra
    sha256 "29b76f520e06b81094b7036d6c8bc1d9e259d2df18dc82514ed1156027dbfa87" => :el_capitan
  end

  # put the highscores file in HOMEBREW_PREFIX/var/brogue/ instead of a
  # version-dependent location.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c999df7dff/brogue/1.7.4.patch"
    sha256 "ac5f86930a0190146ca35856266e8e8af06ac925bc8ae4c73c202352f258669c"
  end

  def install
    (var/"brogue").mkpath

    doc.install "Readme.rtf" => "README.rtf"
    doc.install "agpl.txt" => "COPYING"

    system "make", "clean", "curses"

    # The files are installed in libexec
    # and the provided `brogue` shell script,
    # which is just a convenient way to launch the game,
    # is placed in the `bin` directory.
    inreplace "brogue", %r{`dirname \$0`/bin$}, libexec
    bin.install "brogue"
    libexec.install "bin/brogue", "bin/keymap"
  end

  def caveats; <<~EOS
    If you are upgrading from 1.7.2, you need to copy your highscores file:
        cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
  EOS
  end

  test do
    system "#{bin}/brogue", "--version"
  end
end
