class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.160.tar.gz"
  sha256 "862d9fb75078a91922c72e4a8ed4ef9cb46066cec48f2ab97c29cc90a7402df8"

  bottle do
    cellar :any_skip_relocation
    sha256 "88f46f069e49345090480b29ac8acc0dd7c27c2e04ac896dcbe5ff2bf9a7a530" => :high_sierra
    sha256 "d893a112a8e779fb35cf64cbbf74167ebddaf23368631586abfefbd1c3c082f7" => :sierra
    sha256 "c6184a66ad6e7f367cc9ee10611a22ff1ea5bba739232cb432faa63526bbe8a4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "install", "REV=homebrew"
      prefix.install_metafiles
    end

    bin.install "bin/gofabric8"
  end

  test do
    Open3.popen3("#{bin}/gofabric8", "version") do |stdin, stdout, _|
      stdin.puts "N" # Reject any auto-update prompts
      stdin.close
      assert_match "gofabric8, version #{version} (branch: 'unknown', revision: 'homebrew')", stdout.read
    end
  end
end
