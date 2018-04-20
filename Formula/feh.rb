class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.26.tar.bz2"
  sha256 "b1d6bfdd79060d864b8eff05b916153be04801998148620125e3ac31f99f6c86"

  bottle do
    sha256 "9d758953593395c65cf2ebfd3317763e1e87d738033d8853f492fa304958ae33" => :high_sierra
    sha256 "7027bbe75d5db0a267cf9c40203b53a5457379af20f5fab7678485fb2ac46e3a" => :sierra
    sha256 "062fc4c70e5c344e19b3d7a7ba4a23225fc33702d28852a1da743e0eaa9775e4" => :el_capitan
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = ["verscmp=0"]
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
