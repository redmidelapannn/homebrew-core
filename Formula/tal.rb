class Tal < Formula
  desc "Align line endings if they match"
  # The canonical url currently returns HTTP/1.1 500 Internal Server Error.
  homepage "https://web.archive.org/web/20160406172703/https://thomasjensen.com/software/tal/"
  url "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/misc/tal/tal-1.9.tar.gz"
  mirror "https://web.archive.org/web/20160406172703/https://thomasjensen.com/software/tal/tal-1.9.tar.gz"
  sha256 "5d450cee7162c6939811bca945eb475e771efe5bd6a08b520661d91a6165bb4c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "aef7d5bd5de1e91f309dd210574e4fa9d81a4bd2e2e641f18f54e347ffadd01e" => :sierra
    sha256 "06746d089ea11f615c3c172ac6131cb8eb28ae6fb1a03a139c7c116b3cf41d2c" => :el_capitan
    sha256 "c0b587296d743d09db1934e488c31c08c037dab2f18d244e90ae7ab9c7821e1d" => :yosemite
  end

  def install
    system "make", "linux"
    bin.install "tal"
    man1.install "tal.1"
  end

  test do
    system "#{bin}/tal", "/etc/passwd"
  end
end
