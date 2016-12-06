class DockerLs < Formula
  desc "CLI tools for browsing and manipulating Docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      :tag => "v0.2.0",
      :revision => "45b56b14f05d2e2611a4d6bce7555e8ec04b0c2c"

  head "https://github.com/mayflower/docker-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "14f616762f9f93eefdb77a5ea2e5aa164d708ed5bfda7a794bfe0e449609651c" => :sierra
    sha256 "804cc7cfc85d70f6d3fba3fb591d58ab741b6038a9dab704d3d72441a9181d1d" => :el_capitan
    sha256 "c6842a1d13e640fda7faecf60c87c2e2ac4a35b19917e578bce5eabc1bfbc816" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["AUTO_GOPATH"] = "1"

    system "make"

    bin.install "build/bin/docker-ls" => "docker-ls"
    bin.install "build/bin/docker-rm" => "docker-rm"
  end

  test do
    system "#{bin}/docker-ls", "version"
    system "#{bin}/docker-rm", "version"
  end
end
