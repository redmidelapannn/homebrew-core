class Ndiff < Formula
  desc "Virtual package provided by nmap"
  homepage "https://www.math.utah.edu/~beebe/software/ndiff/"
  url "http://ftp.math.utah.edu/pub/misc/ndiff-2.00.tar.gz"
  sha256 "f2bbd9a2c8ada7f4161b5e76ac5ebf9a2862cab099933167fe604b88f000ec2c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "dbe43031efe6e591cc3af5e315b3c053cf11c325bf52521634363996e2ecb14f" => :el_capitan
    sha256 "8d1b6aab8e6fd4b3c3122410d8195d4b19b7b9ab930471b83ea239154b9131f9" => :yosemite
    sha256 "01f4c7e3606031a57086e141d2a8d95e3bd3efaf3a1f151c16e97fd7e61bc9bc" => :mavericks
  end

  conflicts_with "nmap", :because => "both install `ndiff` binaries"

  def install
    ENV.j1
    # Install manually as the `install` make target is crufty
    system "./configure", "--prefix=.", "--mandir=."
    mkpath "bin"
    mkpath "man/man1"
    system "make", "install"
    bin.install "bin/ndiff"
    man1.install "man/man1/ndiff.1"
  end

  test do
    system "#{bin}/ndiff", "--help"
  end
end
