class Bastet < Formula
  desc "Bastard Tetris"
  homepage "http://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"

  bottle do
    rebuild 2
    sha256 "5e66a2b2adbeec12171e860018dc0b011e7cf9dc5359776347642a3ef875090a" => :high_sierra
    sha256 "b5ce790dab8db9ab54e8cb24b49c878031a13cf15dd1651e7850ce10ef5340ad" => :sierra
    sha256 "787620e1c51cbc0c46dab86386e71ccd351b4a2722ce1950f12088d3adb4fcd0" => :el_capitan
  end

  depends_on "boost"

  # Fix compilation with Boost >= 1.65, remove for next release
  patch do
    url "https://github.com/fph/bastet/commit/0e03f8d4.patch?full_index=1"
    sha256 "9b937d070a4faf150f60f82ace790c7a1119cff0685b52edf579740d2c415d7b"
  end

  def install
    inreplace %w[Config.cpp bastet.6], "/var", var

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end
end
