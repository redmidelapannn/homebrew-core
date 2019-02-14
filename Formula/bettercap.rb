class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.15.tar.gz"
  sha256 "f11fcca8a885dff1176994caa2c2bba65fd335c3750621933ac99ea5ab24647d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9924cb693ef41b8529c2463f7d6b7147a6e53fab223bb6d706c0a7e867daa06b" => :mojave
    sha256 "d338be94b7999d638cbdb6d139f2261ee4380d593704e22bda684722ce6d5879" => :high_sierra
    sha256 "be52c4f6c89f8e4b1b4f1c3083a17f43d87ea39cf29ae016ed6fae411105830d" => :sierra
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
