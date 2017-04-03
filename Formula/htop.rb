class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
  sha256 "179be9dccb80cee0c5e1a1f58c8f72ce7b2328ede30fb71dcdf336539be2f487"

  bottle do
    rebuild 1
    sha256 "5b328b2a67af8c1daeee37049a527049bf6b67e51c0697706d38a5a9066538e0" => :sierra
    sha256 "e2407481bcb87fa1640f4f7b479e34fed62682df47146268d9545551180b9991" => :el_capitan
    sha256 "a69e8400783ce2f05dccb41978fc113faf62dd0b78d4faf04b5dabdb141c9f26" => :yosemite
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

  depends_on "ncurses" => :optional

  conflicts_with "htop-osx", :because => "both install an `htop` binary"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
