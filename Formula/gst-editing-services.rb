class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.12.0.tar.xz"
  sha256 "993372f80cafd5395e90a4bc8bf28733513949a2ae4df987ab0dcc99fc5bab66"

  bottle do
    sha256 "a0307c2322cf577bd8bff8d59d361933d1d45a89a4ba43e49cdf575366209bed" => :sierra
    sha256 "21597db137dfed22baac5795a75476b4a110a0ecc4872b8a2612a41e63caeeeb" => :el_capitan
    sha256 "58c1aa539a373425858f485e29d363c99bf9ee36c25515d8d382fa1c46b8691c" => :yosemite
  end

  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk-doc",
                          "--disable-docbook"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
