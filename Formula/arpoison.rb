class Arpoison < Formula
  desc "UNIX arp cache update utility"
  homepage "http://www.arpoison.net/"
  url "http://www.arpoison.net/arpoison-0.7.tar.gz"
  sha256 "63571633826e413a9bdaab760425d0fab76abaf71a2b7ff6a00d1de53d83e741"

  bottle do
    cellar :any
    sha256 "67511ad97eb3fd0ef6276af5e2502b25f7a7ef4c4cd0f89e5e5bf32c589129a4" => :sierra
    sha256 "52ac8e7ea13b83ff250beeeea8026d6045aa3447e69285f56c733b7b6b68893c" => :el_capitan
    sha256 "3f23e0e51ea21834fe099d1975c920f7a406c18848af6d259fc592b55340ce83" => :yosemite
  end

  depends_on "libnet"

  def install
    system "make"
    bin.install "arpoison"
    man8.install "arpoison.8"
  end

  test do
    # arpoison needs to run as root to do anything useful
    assert_match "target MAC", shell_output(bin/"arpoison", 1)
  end
end
