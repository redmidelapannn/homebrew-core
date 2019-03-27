class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.21.tar.gz"
  sha256 "367d9b28ee0ce13f272995ae5a5cafdf80a563c43d579933b596ad3d47c06edb"

  bottle do
    cellar :any
    sha256 "cbeacb5ccf8c36c7c8f4420b12a457599b7833f592ac35d8a47ba52d8b796e21" => :mojave
    sha256 "d0318121e75e8b0bb1a1637fe2b1881573bf95fd9047d03e327bf1773e856836" => :high_sierra
    sha256 "9db87ef2aaba28a3d915cec1b4928783095104b491a94f701045fd2423c94569" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

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
