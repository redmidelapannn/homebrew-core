class CloudNuke < Formula
  desc "Clean up your cloud accounts by nuking all resources in it"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.4.tar.gz"
  sha256 "ce2f5caff4db80accc9ceaeef859382135e772dfd08d1bf981e52098512c45f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "169f15604288077c6ca42719c5ff359fe5dbe7a20cb1fde557fafb0eca6f8769" => :mojave
    sha256 "0caeb48e16635cd22bcc4e665144930838ec3f655987165696773a463c26a5e3" => :high_sierra
    sha256 "043fb1a8e94709f542f9a68b5b680b64c0e9c78d305c1face1516c0cd7151e2e" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    print buildpath
    ENV["GOPATH"] = buildpath
    cloud_nuke_path = buildpath/"src/github.com/gruntwork-io/cloud-nuke/"
    cloud_nuke_path.install buildpath.children

    cd cloud_nuke_path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.VERSION=#{version}"
      bin.install "cloud-nuke"
    end
  end

  test do
    assert_match "cloud-nuke version 0.1.4", shell_output("#{bin}/cloud-nuke -v ")
  end
end
