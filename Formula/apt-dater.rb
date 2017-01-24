class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://github.com/DE-IBH/apt-dater"
  url "https://github.com/DE-IBH/apt-dater/archive/v1.0.3.tar.gz"
  sha256 "891b15e4dd37c7b35540811bbe444e5f2a8d79b1c04644730b99069eabf1e10f"
  version_scheme 1

  bottle do
    rebuild 2
    sha256 "039df1ebe2f08d24ea3fa26c91644e084c36b9ad9803b5590667eeeec00780f0" => :sierra
    sha256 "8f78046980e0ee6f824337539df87000710e2301ca54ba0ad51b091d4097c407" => :el_capitan
    sha256 "74f9703885181718069109713f9e11fc214b4ae1b3c99c7cd34d41c18cccf968" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "AM_LDFLAGS=", "install"
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
