class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://downloads.sourceforge.net/project/gpredict/Gpredict/2.0/gpredict-2.0.tar.gz"
  sha256 "508f882383eac326aecb0b058378fc71f13b431c581e0efc28ee3c4216c76e16"

  bottle do
    sha256 "62c56ff78bccab17e95cfb5b930ef38823683a14f10dfe5e7e971586cc0d3378" => :high_sierra
    sha256 "b4063816617f5c10308089e5b4ca808d53230d60504e97f790615b454dfc35f8" => :sierra
    sha256 "44f0d0a3db18b8dc60762266591654ac342f6e68f52359c8adc726ca8f1c258f" => :el_capitan
  end

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+"
  depends_on "hamlib"
  depends_on "adwaita-icon-theme"

  def install
    gettext = Formula["gettext"]
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gpredict", "-h"
  end
end
