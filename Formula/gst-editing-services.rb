class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.12.3.tar.xz"
  sha256 "032e2fd040079259aec060d526bcb021c670f8d953219c229f80fdc541465f76"

  bottle do
    sha256 "3c9b3b4fa98225c1a297e4de4aae5d308f463787a3e5f2d32142e4038ce2bbb4" => :high_sierra
    sha256 "cd2c43b4b67a326d2f553fd889c61ef58a3d3387df19a9209e463b3dce6c9a0d" => :sierra
    sha256 "d32843906b0e5a1644f3117c178790e22049cf518b2e1fcbd3337cad55ced46d" => :el_capitan
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
