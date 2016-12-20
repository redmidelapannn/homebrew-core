class HtopOsx < Formula
  desc "Improved top (interactive process viewer) for macOS"
  homepage "https://github.com/max-horvath/htop-osx"
  url "https://github.com/max-horvath/htop-osx/archive/0.8.2.8.tar.gz"
  sha256 "3d8614a3be5f5ba76a96b22c14a456dc66242c5ef1ef8660a60bb6b766543458"

  bottle do
    rebuild 2
    sha256 "612b4094880b4420cf24919a051ee65dbae5df8faa9ad0b25cefcdc91adec0fb" => :sierra
    sha256 "98c10215e0cb7fe7f022f20904a2e5d3fa86985f7426d3c41e68aaa15311f60f" => :el_capitan
    sha256 "bcc351fb8190489073d1fb57666c09c38e77598f33adf0be7c4abf3fc6d06df7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "htop", :because => "both install an `htop` binary"

  def install
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
