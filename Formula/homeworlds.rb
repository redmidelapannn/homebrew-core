class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
    :revision => "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  revision 1

  bottle do
    cellar :any
    sha256 "e615cfc61ddc9b009b5592f781a0034aca007804997fe32dc9f1da9e5f182294" => :mojave
    sha256 "0d1a8850f87f70745c654913b017c00cc2ca3979f8f1cdb74fd6b9c496196dc7" => :high_sierra
    sha256 "f8156ead5a550da4f263a9a359149184417d1d0061384971d4a78a4099bd7166" => :sierra
  end

  depends_on "wxmac"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end
