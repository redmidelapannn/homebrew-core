class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.18.tar.gz"
  sha256 "eaa098784d05a14042c53b89b4ca456f8de972dc1fbf96d4fc09f96004e0f5e1"

  bottle do
    sha256 "1a2c99421538d81ab56f13dc0c4b539f80288f9a8dba2ef3c2acb6d3b397ef09" => :el_capitan
    sha256 "2a982c65ea3f7d288e3cc1aec83d032321b55dd47ef3f397d9db1bf1a7d51401" => :mavericks
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
