class GnomeCommon < Formula
  desc "Core files for GNOME"
  homepage "https://git.gnome.org/browse/gnome-common/"
  url "https://download.gnome.org/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz"
  sha256 "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a4f1bdb569e2fb0f68401c42fecb7863bfb4483673bda174407085b8b4580782" => :sierra
    sha256 "a4f1bdb569e2fb0f68401c42fecb7863bfb4483673bda174407085b8b4580782" => :el_capitan
    sha256 "a4f1bdb569e2fb0f68401c42fecb7863bfb4483673bda174407085b8b4580782" => :yosemite
  end

  conflicts_with "autoconf-archive",
    :because => "both install certain autoconf macros"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
