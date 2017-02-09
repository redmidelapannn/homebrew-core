class Ec2backup < Formula
  desc "Simple AWS EC2 backup command line application for MacOS, Windows and Linux"
  homepage "https://github.com/tanis2000/ec2backup"
  url "https://github.com/tanis2000/ec2backup/archive/v0.1.1.tar.gz"
  sha256 "555ddbf513f956699564254ec368db0b4c628319aaee957feb905b7860b8020f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ff53b3ee32889c2e43e3b05330288f062360f5d97f3cd44aebb974f8549ae8f" => :sierra
    sha256 "85148217a36fa2ce480191506dcdb82f029ed6d41c3853338b2a258d9f1126c3" => :el_capitan
    sha256 "9f1402b301109ce4f3b50f5a5954dc3131f15c76f5b65a407adc8e61e19a8f5b" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath.to_s
    mkdir_p buildpath/"src/github.com/tanis2000"
    ln_s buildpath, buildpath/"src/github.com/tanis2000/ec2backup"
    system "go", "install", "github.com/tanis2000/ec2backup"
    bin.install "#{buildpath}/bin/ec2backup"
  end

  test do
    system "#{bin}/ec2backup", "--version"
  end
end
