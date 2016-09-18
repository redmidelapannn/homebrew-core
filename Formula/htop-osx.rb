class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for OS X"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.8.tar.gz"
  sha256 "3d8614a3be5f5ba76a96b22c14a456dc66242c5ef1ef8660a60bb6b766543458"

  bottle do
    rebuild 2
    sha256 "5585fc23a9d2deaa62586a4a432f5e143b2eb783fcf31c99a780eb10295a19b4" => :sierra
    sha256 "fcfb9e74c298db6549551d043c9d3f49ced3bccbeacede8e13a4d48220cd3e16" => :el_capitan
    sha256 "265dd5c7c26e72d13004e0aa9e8684755ace6b6674ab937ac00d8964de2eed01" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "htop", :because => "both install an `htop` binary"

  def install
    # Otherwise htop will segfault when resizing the terminal
    ENV.no_optimization if ENV.compiler == :clang

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install", "DEFAULT_INCLUDES='-iquote .'"
  end

  def caveats; <<-EOS.undent
    htop-osx requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
