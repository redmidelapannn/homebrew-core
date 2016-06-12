class Dircproxy < Formula
  desc "IRC proxy server (AKA 'bouncer')"
  homepage "https://github.com/w8tvi/dircproxy"
  url "https://dircproxy.googlecode.com/files/dircproxy-1.2.0-RC1.tar.gz"
  sha256 "40ad50ffd13681114f995519dc3f65f48cb5eac41e780ad14ce8ffd49463757f"

  bottle do
    revision 1
    sha256 "2e42623d53202a0ed7c76e7e9490bb95055bfceec1daee854b1746f73d96d2bd" => :el_capitan
    sha256 "5f9bec3190e4dbf8c58c719de4f28c1fa86be764be4d07ce3570524da0c49bec" => :yosemite
    sha256 "eaffc5bbb87969b843917eed0ee60d803cd19ad09c4d8db77452ec8784e1bde5" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ssl"
    system "make", "install"
  end
end
