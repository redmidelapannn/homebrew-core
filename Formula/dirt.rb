class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  head "https://github.com/tidalcycles/Dirt.git"
  revision 1

  bottle do
    cellar :any
    sha256 "f3082f9020f27661cbda367e48a67d83c279bb30526186e969971060d9b812e7" => :el_capitan
    sha256 "92103bb2be80bac4689ebb1e6105ef9159f0cb1e9a24d842ddf017b6882265cf" => :yosemite
    sha256 "8e773863966ac888da470be71bb9d250787fe08ecc078d64428842ad342dba76" => :mavericks
  end

  depends_on "jack"
  depends_on "liblo"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dirt --help; :")
  end
end
