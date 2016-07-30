class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "http://ngspice.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz"
  sha256 "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108"

  bottle do
    revision 1
    sha256 "4570256aa85a410af403b9d670ee50782dbdda5d98ab26a6bda4d56e9b484615" => :el_capitan
    sha256 "6f24ff9d3dc15dbab8448894babac7f532cfa8d6d3493c3a68c10b546a460b00" => :yosemite
    sha256 "ffd5832756fa352029384986525d54ad83caa96996a61596fc64b97d865da50d" => :mavericks
  end

  option "without-xspice", "Build without x-spice extensions"

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
