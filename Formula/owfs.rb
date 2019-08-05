class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://owfs.org/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p3/owfs-3.2p3.tar.gz"
  version "3.2p3"
  sha256 "b8d33eba57d4a2f6c8a11ff23f233e3248bd75a42c8219b058a888846edd8717"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e0c3d9159645eaa70d575967dced6c518320ea9bce011c2da56ade106fb1ec4b" => :mojave
    sha256 "470c58e9bca6de860f4d212f04a3b09e92ff1eab3127dda9d7126bb50edb1584" => :high_sierra
    sha256 "09e26614627f05d7e0f89e1bca951458111510e05a22812265374ed9a81ddc76" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--disable-swig",
                          "--enable-ftdi",
                          "--enable-usb",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"owserver", "--version"
  end
end
