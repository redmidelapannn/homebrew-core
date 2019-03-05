class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "https://packages.debian.org/sid/dns2tcp"
  url "https://deb.debian.org/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fcc8c99dff63edab1317b6c3ef1945a762cc153ec984bc500608966c24f9b869" => :mojave
    sha256 "045e8527ef6d3b695e5c8a8054b2110c537e5b3a0800e645afbb0eab694064bc" => :high_sierra
    sha256 "57016223e37cc946d12947dc69859356c921da5b80cdd8e7e6d838dc1432103b" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match(/^dns2tcp v#{version} /,
                 shell_output("#{bin}/dns2tcpc -help 2>&1", 255))
  end
end
