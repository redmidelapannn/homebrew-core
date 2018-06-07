class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.6.tar.gz"
  sha256 "f91761fbaf16b3fdde3c89fec05f4a72684f8e444af66f712146beac8e88e8f6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ad7d0f8d538c4092f8febb382978839297760edd56ca22261adfc162aecac1f1" => :high_sierra
    sha256 "e231f91ca3bcd5c8b18d5141e5718e32c537b9c82d8f1dec80e9fb351cc5e49c" => :sierra
    sha256 "5e007786b337d777fc36aa5c76be8696939ebf53b9f11c0ece87ee5edebad2b0" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
