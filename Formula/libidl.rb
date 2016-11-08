class Libidl < Formula
  desc "Library for creating CORBA IDL files"
  homepage "https://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/"
  url "https://download.gnome.org/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2"
  sha256 "c5d24d8c096546353fbc7cedf208392d5a02afe9d56ebcc1cccb258d7c4d2220"

  bottle do
    cellar :any
    rebuild 2
    sha256 "289d969e9eebad29fd7ce8b41847daec33b1fd1193f0ffeab7c620fda1e5e213" => :sierra
    sha256 "e78db08d2a4a9bd9e1309eff88a60e212056a52f089425d9b816019a4aafbc19" => :el_capitan
    sha256 "7fb174ddd609721ab817d9fe11987d70d40451654aa001954c8be7ff6ad9895d" => :yosemite
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
