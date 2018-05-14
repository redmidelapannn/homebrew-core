class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "https://dlbeer.co.nz/mspdebug/"
  url "https://github.com/dlbeer/mspdebug/archive/v0.25.tar.gz"
  sha256 "347b5ae5d0ab0cddb54363b72abe482f9f5d6aedb8f230048de0ded28b7d1503"
  head "https://github.com/dlbeer/mspdebug.git"

  bottle do
    rebuild 1
    sha256 "6ebd117045392d6d922b82c8452107c86a216f22f6ec7aa1c0a538ec7293baad" => :high_sierra
    sha256 "755e7164616ca7fbcb31be90ec9352734667e430c989e1ba473f06fd5629255b" => :sierra
    sha256 "ce1077c3133323c2c673075f7da1e11c2e33a109e3334981242d51855dc199ac" => :el_capitan
  end

  depends_on "hidapi"
  depends_on "libusb-compat"

  def install
    ENV.append_to_cflags "-I#{Formula["hidapi"].opt_include}/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<~EOS
    You may need to install a kernel extension if you're having trouble with
    RF2500-like devices such as the TI Launchpad:
      https://dlbeer.co.nz/mspdebug/faq.html#rf2500_osx
    EOS
  end

  test do
    system bin/"mspdebug", "--help"
  end
end
