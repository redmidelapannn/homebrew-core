class EmsFlasher < Formula
  desc "Software for flashing the EMS Gameboy USB cart"
  homepage "https://lacklustre.net/projects/ems-flasher/"
  url "https://lacklustre.net/projects/ems-flasher/ems-flasher-0.03.tgz"
  sha256 "d77723a3956e00a9b8af9a3545ed2c55cd2653d65137e91b38523f7805316786"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f513128bf1f4ebe1a4c0b4763afcf8420145b7088a57979459be8f35315aed28" => :sierra
    sha256 "e683d995b323b155012397c4bcaafd23928703ccad5645abf0c84efc73681fad" => :el_capitan
    sha256 "5d02ca0380c205c0aeecbb9e96de103995ad050125bc74e2fb0c6c418bbad31e" => :yosemite
  end

  head do
    url "https://github.com/mikeryan/ems-flasher.git"
    depends_on "gawk" => :build
    depends_on "coreutils" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    if build.head?
      system "./config.sh", "--prefix", prefix
      man1.mkpath
      system "make", "install"
    else
      system "make"
      bin.install "ems-flasher"
    end
  end

  test do
    system "#{bin}/ems-flasher", "--version"
  end
end
