class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://github.com/owfs/owfs/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p2/owfs-3.2p2.tar.gz"
  version "3.2p2"
  sha256 "39535521a65a74bd36dc31726bcf04201f60f230a7944e9a63c393c318f5113c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cb30521ed6da7399254331f6e3d5fbdc501d5944a439f4aaaa26929b348d4675" => :mojave
    sha256 "5551702e44432f746436ce6acc5bf0892a40c4aad876f3f2ecea748478791a3e" => :high_sierra
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
