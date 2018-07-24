class Cotton < Formula
    desc "Markdown Test Specification Runner"
  bottle do
    cellar :any_skip_relocation
    sha256 "d994a924dabf56f56e36abb24c4b0f49041809dea298fa7a04e2b036d276458a" => :high_sierra
    sha256 "b79cb4a6ecf9b623f631540ddbfda11c56b7031eb5579769da4d7fb814eeed13" => :sierra
    sha256 "4bcdd37141fa1db533799a3ee31335329fcf44a5f17ca47f0fd20d5ce4f9d7bc" => :el_capitan
  end

    homepage "https://github.com/chonla/cotton"
    url "https://github.com/chonla/cotton/archive/0.1.17.tar.gz"
    sha256 "f199d6672b75dcefa8c517ddbbc4b94a8df2289597f6b598e0c37b211a3f6766"
    depends_on "go" => :build

    def install
        system "bash", "build.sh"
        bin.install "/tmp/.gobuild/bin/cotton" => "cotton"
    end

    test do
        system "#{bin}/cotton", "-v"
    end
end
