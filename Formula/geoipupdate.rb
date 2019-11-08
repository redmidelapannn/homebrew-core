class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.1.4.tar.gz"
  sha256 "787e0c8e90fdc1f6d13de680ceedb594fcafc2df0ba4dd3582aa7320ca52e31e"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c14436883893e8a74960e6b676651de8b03f9c1299a857a24e59aa31f7a22361" => :catalina
    sha256 "e8344b81052f5e78906172f5f85cbb611353ebf260984f9772eca4605790a3ae" => :mojave
    sha256 "ad2d0b4e4a5e281ff8f0d06b8e0b28e1e677fe299816c40ec4d0e88b1d0192ba" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/maxmind/geoipupdate").install buildpath.children

    cd "src/github.com/maxmind/geoipupdate" do
      system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

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
