class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.1.0/htop-2.1.0.tar.gz"
  sha256 "3260be990d26e25b6b49fc9d96dbc935ad46e61083c0b7f6df413e513bf80748"

  bottle do
    sha256 "d9ec4f8f7cab0ad2241421d986fef89c2ae0b1b4abdb67a3e0ffbbc991f46973" => :high_sierra
    sha256 "15fbf786ab3d4561a5933bf5cf18193b9ce936d282cb1cbfab83e052d9b8a28d" => :sierra
    sha256 "7d2273428fd68dff8fd52621442d2b581bc985d790e4759afa5b01e17453f1aa" => :el_capitan
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

  depends_on "pkg-config" => :build
  depends_on "ncurses" => :optional

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
