class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180826150943.tar.gz"
  sha256 "1874de8a696848b43e072eabc40dc2656160e119162e0e83d6982a0a08e1d033"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc678e1656a1a00dc3c9aeaea76f6114bd5fec9c0f40b520a1a25c97ce946d9" => :mojave
    sha256 "9b88842d39f15077debfbad25af2bc8dfe265ee0af308f56d33f68b0ffdf2be2" => :high_sierra
    sha256 "387ba32a7a03842f90d6569d772358ad956137242318195dd3fcd60ca580f9a2" => :sierra
    sha256 "26638eaf61040da3066ad620b7d2df6a48a83cf156139cf26ad258307d98f5b6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
