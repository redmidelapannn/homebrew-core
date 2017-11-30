class Gsound < Formula
  desc "Small library for playing system sounds"
  homepage "https://wiki.gnome.org/Projects/GSound"
  url "https://download.gnome.org/sources/gsound/1.0/gsound-1.0.2.tar.xz"
  sha256 "bba8ff30eea815037e53bee727bbd5f0b6a2e74d452a7711b819a7c444e78e53"

  bottle do
    sha256 "f2d8c964103a8a04b53751bccd63e13f207ce4f8fbec972871451391a3af53f2" => :high_sierra
    sha256 "34eb6e8460916fdecfead37eecd9c72571ca0ee30480b96bf2d7c465a6619790" => :sierra
    sha256 "be53025b52cc7756349ad9dec8857dd351137b9ef7cd931f3f45d3bc6849b3c3" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libcanberra"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-static
      --disable-gtk-doc
    ]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    ["python", "python3"].each do |python|
      system python, "-c", "from gi.repository import GSound"
    end
  end
end
