class Arpoison < Formula
  desc "UNIX arp cache update utility"
  homepage "http://www.arpoison.net/"
  url "http://www.arpoison.net/arpoison-0.7.tar.gz"
  sha256 "63571633826e413a9bdaab760425d0fab76abaf71a2b7ff6a00d1de53d83e741"
  revision 1

  bottle do
    cellar :any
    sha256 "fd2efb4f052a896d66f46b1b95d9a546a1ef274c1a1500083ac19f262d4de046" => :mojave
    sha256 "926f32180de6cb036198a23812d962ec93bee64b8a1367b32556925c9f0ae49e" => :high_sierra
    sha256 "c1acbb73c3bfc838630f10a73e5366484bda1dbba82a1d333050a9fd1ffc2ba9" => :sierra
  end

  depends_on "libnet"

  def install
    system "make"
    bin.install "arpoison"
    man8.install "arpoison.8"
  end

  test do
    # arpoison needs to run as root to do anything useful
    assert_match "target MAC", shell_output("#{bin}/arpoison", 1)
  end
end
