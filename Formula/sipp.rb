class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.io/"
  url "https://github.com/SIPp/sipp/releases/download/v3.5.2/sipp-3.5.2.tar.gz"
  sha256 "875fc2dc2e46064aa8af576a26166b45e8a0ae22ec2ae0481baf197931c59609"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "adf04af6d1f5fee15a94895dc6970c7f80667b97994a94fa2cb773382efafdd2" => :mojave
    sha256 "217eb591389cbae6338201758d6db6fe9433159ad81e36829e048885cd9861f7" => :high_sierra
    sha256 "c298e237fb4e4ae7ddc4fed01b7b0ea1b7eea24f8de806f3f739f07f44ec9b67" => :sierra
    sha256 "acfa510fd33b9445edb0860f9cf1b080c08fd1fcb0b7ddfc3cdaf0c064922e42" => :el_capitan
  end

  def install
    system "./configure", "--with-pcap"
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
