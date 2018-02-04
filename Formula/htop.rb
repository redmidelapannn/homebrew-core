class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  revision 1

  stable do
    url "https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
    sha256 "179be9dccb80cee0c5e1a1f58c8f72ce7b2328ede30fb71dcdf336539be2f487"

    # Running htop can lead to system freezes on macOS 10.13
    # https://github.com/hishamhm/htop/issues/682
    depends_on MaximumMacOSRequirement => :sierra
  end

  bottle do
    rebuild 1
    sha256 "b237b596a4f579ba8f713f633f437118db50be521b559f98655579c282b97aac" => :sierra
    sha256 "ba0d3b028c037bdf2521790c11d16ffbadc03c9e2d178cb882aa70247d263b09" => :el_capitan
  end

  devel do
    url "https://github.com/hishamhm/htop/archive/3.0.0beta1.tar.gz"
    sha256 "6cb11e4ccbbb956bc71e224d0923e1ee7471023eef482f2a2ee50b27930be48e"
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

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
