class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "http://ngspice.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz"
  sha256 "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108"

  head do
    url "git://ngspice.git.sourceforge.net/gitroot/ngspice/ngspice"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  bottle do
    rebuild 1
    sha256 "09203a7877d296eda56901f3e0a906869fe67c623c9bcdb1c5087849f3720f87" => :el_capitan
    sha256 "fc0e78f95302debeae3e11de3d85cdb25008399e44a77518da9f26738a4071ce" => :yosemite
    sha256 "44db2de16d266833283b3e501db4afbdc10f9a576fa845ff48ad21eb4a143a5e" => :mavericks
  end

  option "without-xspice", "Build without x-spice extensions"

  deprecated_option "with-x" => "with-x11"

  depends_on :x11 => :optional

  def install
    system "./autogen.sh" if build.head?

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
