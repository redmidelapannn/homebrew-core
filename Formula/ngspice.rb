class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "http://ngspice.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz"
  sha256 "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108"

  bottle do
    revision 1
    sha256 "f6cd3a5ec6a422b6b350a06d63c53a5b924f1ecb7125da3402464eae6dc966c6" => :el_capitan
    sha256 "2acd22d5742c953708334d7fe541011c03234a147e0fb781506217e1678b0686" => :yosemite
    sha256 "4ff038f72580e4369c962573439483b7bd9f96b4cf067067d56666fbbc2114db" => :mavericks
  end

  option "without-xspice", "Build without x-spice extensions"
  option "with-shared", "Build shared library"

  deprecated_option "with-x" => "with-x11"

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-editline=yes
    ]
    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end
    args << "--enable-xspice" if build.with? "xspice"

    if build.with? "shared"
      # The build system cannot build both the executable and the shared
      # library in one sequence, see
      # https://sourceforge.net/p/ngspice/support-requests/19 .
      # But we can build the shared library first, clean up, and then build
      # the executable.
      args << "--with-ngshared"
      system "./configure", *args
      system "make", "install"
      system "make", "clean"
      args.pop
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cir").write <<-EOS.undent
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
