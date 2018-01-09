class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "https://packages.debian.org/sid/dns2tcp"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b056139401a10cdd7e5faae4f92824bc40703c5a17c4451a85d5290f9469bcec" => :high_sierra
    sha256 "bf17f3a1d03908e182c3be7ce152baf6f8535c1d838c9470ac81523006a05ffb" => :sierra
    sha256 "574bcb2776854172317c9fb04f06ae90d337e9dbe65ddb15e53b605f181de4b5" => :el_capitan
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
