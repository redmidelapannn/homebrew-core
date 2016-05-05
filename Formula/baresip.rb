class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.18.tar.gz"
  sha256 "eaa098784d05a14042c53b89b4ca456f8de972dc1fbf96d4fc09f96004e0f5e1"

  bottle do
    sha256 "76fdca19e63379b8025fcaeb07af7507aa2b9e7f8e2cb841566bb5f75666bcbb" => :el_capitan
    sha256 "7dde9d5c78057172e3d1e2cbcd960c70320b7a2cd903ace594bd70bbd324533a" => :mavericks
  end

  depends_on "librem"
  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}",
                              "MOD_AUTODETECT=",
                              "USE_AVCAPTURE=1",
                              "USE_COREAUDIO=1",
                              "USE_G711=1",
                              "USE_OPENGL=1",
                              "USE_STDIO=1",
                              "USE_UUID=1"
  end

  test do
    system "#{bin}/baresip", "-f", "#{ENV["HOME"]}/.baresip", "-t"
  end
end
