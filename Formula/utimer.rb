class Utimer < Formula
  desc "Multifunction timer tool"
  homepage "https://launchpad.net/utimer"
  url "https://launchpad.net/utimer/0.4/0.4/+download/utimer-0.4.tar.gz"
  sha256 "07a9d28e15155a10b7e6b22af05c84c878d95be782b6b0afaadec2f7884aa0f7"

  bottle do
    rebuild 1
    sha256 "35e26988242ad2d346b781e0e636086be0e3b759102f87826f223b284c29c439" => :sierra
    sha256 "ed04357b4901c847c18f115284974fa0a249036ca5256b5d36d08b61ad407098" => :el_capitan
    sha256 "8eb8548c13c553ae16d2dc54c2b8a89ccc9ec46a35b306512320f736b99d0939" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Elapsed Time:", shell_output("#{bin}/utimer -t 0ms")
  end
end
