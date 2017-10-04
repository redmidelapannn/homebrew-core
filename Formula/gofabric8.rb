class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.162.tar.gz"
  sha256 "e1eee26bebf4fa4e0d499d228cd80ec22f17ff2eb7a24e10d2d040e3878b205e"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc5e5ffaf99541c1bd5582079324b9935ba5c704bd968ebea175ac72ec8db128" => :high_sierra
    sha256 "781507a82e18114b38022ff2eb0952dcd755548a9fe9f789fbb6e44e6d751c72" => :sierra
    sha256 "692bb0244af20cc7508659b22f695e6c9f5b29dd89dd65d232df198482562ffc" => :el_capitan
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
