class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/30/ngspice-30.tar.gz"
  sha256 "08fe0e2f3768059411328a33e736df441d7e6e7304f8dad0ed5f28e15d936097"
  revision 1

  bottle do
    rebuild 1
    sha256 "398d902a25a82f58195d431a074fd78813572a4abb3c849367ee44c9b14aee00" => :mojave
    sha256 "851670913f0651af2b7b2f7c50136abcb855c737a1a220f276255e8da6da3699" => :high_sierra
    sha256 "f8992bf9236148172ea5e40fa161f1de2d2f46f6199c495a0e89087dcc0a5664" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system "#{bin}/ngspice", "test.cir"
  end
end
