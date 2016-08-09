class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/direnv/direnv/archive/v2.9.0.tar.gz"
  sha256 "023d9d7e1c52596000d1f4758b2f5677eb1624d39d5ed6d7dbd1d4f4b5d86313"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "00885bfe9b49f7326d22ec0d596459e4dddc3ef48a64712af58209bcb71bf4c8" => :el_capitan
    sha256 "03631bde2bc7bfee6ab8c44432bc27c5c2b80d4cd63952ff72971fd7fd31f900" => :yosemite
    sha256 "288117b508be30e85ea73bab80b7675d5cf6e40135ad1133bb0c82dd4e88055e" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
