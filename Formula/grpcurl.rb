class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.0.0.tar.gz"
  sha256 "7bb34f0bc08046feb093871898b1abc197cd75054dd80bd73167246caadd094c"

  bottle do
    cellar :any_skip_relocation
    sha256 "af253d7273fc8fddc2998a49c9f77b11f89dc1fe8657e304df0ec5bee27cd0f7" => :mojave
    sha256 "34c040404de3beac4bc2f58f6d3774dfe3ee3b581e84983a0299745acc6c1dc7" => :high_sierra
    sha256 "c639660c70fc938f98fafcd5d8cc4f3ceee778070bf94d5b0da76abe83d5d924" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/fullstorydev/grpcurl").install buildpath.children
    cd "src/github.com/fullstorydev/grpcurl/cmd" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
             "-o", bin/"grpcurl", "./..."
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/grpcurl", "-help"
  end
end
