class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.161.tar.gz"
  sha256 "dc47b8a5eec9bc376329515947b81d4d3a0acada1bfef76a7b342c824ae77068"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d1519f26aa456b0565c7012611ec47d6dbb017f9fd4c3029013a19b989b788e" => :high_sierra
    sha256 "8346a704bd7eae32d1da061849d61615c0daba2f01c7ffc088ef1c10659cd078" => :sierra
    sha256 "f7a132388c2b66b4629cac5ccf54fe4234da579424cc1fb99f5f63727d55730b" => :el_capitan
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
