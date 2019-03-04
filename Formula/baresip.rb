class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.6.1.tar.gz"
  sha256 "b559c5ca75bd066fb6f51b2e371641392b9464309b4ed44429af406b2d6cd8d9"

  bottle do
    sha256 "c764add54fd2e90c06dc72b25007d1719b58fc641364faa3d448a1a13e323f0d" => :mojave
    sha256 "a3921c893d9e55a114df6afedcb4341de985ef72b8650aefed4d24418f428f84" => :sierra
  end

  depends_on "libre"
  depends_on "librem"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}",
                              "HAVE_GETOPT=1",
                              "MOD_AUTODETECT=",
                              "USE_AVCAPTURE=1",
                              "USE_CONS=1",
                              "USE_COREAUDIO=1",
                              "USE_G711=1",
                              "USE_OPENGL=1",
                              "USE_STDIO=1"
  end

  test do
    system "#{bin}/baresip", "-f", "#{ENV["HOME"]}/.baresip", "-t"
  end
end
