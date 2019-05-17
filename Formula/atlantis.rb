class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io"
  url "https://github.com/runatlantis/atlantis/archive/v0.7.2.tar.gz"
  sha256 "ecb0068f6ee1cacc4710b4f77e67b88e5d6b5d1dfae3bf6ce480980c93efa50d"
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    dir = "src/github.com/runatlantis/atlantis"
    build_dir = buildpath/dir
    build_dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "atlantis"
      bin.install "atlantis"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"atlantis", "version"
  end
end
