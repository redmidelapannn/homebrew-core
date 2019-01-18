class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.2.tar.gz"
  sha256 "76a2bd8e75fbe1d88cfdf0ab7f00e90cfea7c87b8757d6f5147a3d4d2d9773b3"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "07309a0425f6b037418096c735ce264755b326c257fa8cd55fbf747250da2511" => :mojave
    sha256 "531471160dcacb6ebecd75dfc2e915e2ca666f85aa5c6e8b8f5b1acddac0e764" => :high_sierra
    sha256 "26c52c2addfd4c8b7ab23c644b29c526ba8a87327ae860b6d2f4fc6d5eb37f47" => :sierra
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/maxmind/geoipupdate").install buildpath.children

    cd "src/github.com/maxmind/geoipupdate" do
      system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP"

      bin.install  "build/geoipupdate"
      etc.install  "build/GeoIP.conf"
      man1.install "build/geoipupdate.1"
      man5.install "build/GeoIP.conf.5"
    end
  end

  def post_install
    (var/"GeoIP").mkpath
    system bin/"geoipupdate", "-v"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
