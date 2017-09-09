class NeopopSdl < Formula
  desc "NeoGeo Pocket emulator"
  homepage "https://nih.at/NeoPop-SDL/"
  url "https://nih.at/NeoPop-SDL/NeoPop-SDL-0.2.tar.bz2"
  sha256 "2df1b717faab9e7cb597fab834dc80910280d8abf913aa8b0dcfae90f472352e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bda48790d66bd3cdc9af372ac3233cb9918354af64e63a883d37e80f064923e2" => :sierra
    sha256 "a41a72be809263ed03119d9809a5775a8ff816ad34311d44bbf89c76312a1c1f" => :el_capitan
    sha256 "418882d6fbe9ff41272dba21ac98c9e5379bb7210419c19f6731ea7ef8bfb558" => :yosemite
  end

  head do
    url "https://hg.nih.at/NeoPop-SDL/", :using => :hg
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
    depends_on "ffmpeg"
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_equal "NeoPop (SDL) v0.71 (SDL-Version #{version})", shell_output("#{bin}/NeoPop-SDL -V").chomp
  end
end
