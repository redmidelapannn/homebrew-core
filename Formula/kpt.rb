class Kpt < Formula
  desc "Toolkit to manage,and apply Kubernetes Resource config data files"
  homepage "https://googlecontainertools.github.io/kpt"
  url "https://github.com/GoogleContainerTools/kpt/archive/v0.4.0.tar.gz"
  sha256 "63133d79cebfda47a281bee31bf10e1ec6f40556d6dac32546a54e91ee58ce9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1286f1c1bbcb99f6593745eda18e1c88cc041d6503e954028ab78abea711a2fa" => :catalina
    sha256 "f0396c0825a77f2c6afb09e49a1d69a70f819174165a162197e82f3a54029061" => :mojave
    sha256 "185068c91aa3e6c9ae3de40bed5f458b414ed953698adfaea1a572404e3d9474" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    system "go", "build", "-ldflags", "-X main.version=#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")
  end
end
