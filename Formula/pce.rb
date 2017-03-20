class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 1

  head "git://git.hampa.ch/pce.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bb1d589296d6251055d325c84775d33b2622afbfbd3ec8a91a0974295529f1ee" => :sierra
    sha256 "9d6d39a86e00579bd28e13bb4000a1c3c0ea959e8225b0bd3848b4cff1ddf093" => :el_capitan
    sha256 "cd3a57c1655a3cdb128c875443e05709e37cd936ed1cc0a8e9127cc55e6b46e9" => :yosemite
  end

  devel do
    url "http://www.hampa.ch/pub/pce/pre/pce-20170208-df19414/pce-20170208-df19414.tgz"
    version "20170208"
    sha256 "aaad3db24b5fabbd308afbb8d2f242236b8abf7d48b010f726a4367f16ec2681"
  end

  depends_on "sdl"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--enable-readline"
    system "make"

    # We need to run 'make install' without parallelization, because
    # of a race that may cause the 'install' utility to fail when
    # two instances concurrently create the same parent directories.
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/pce-ibmpc", "-V"
  end
end
