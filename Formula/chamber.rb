class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.1.0.tar.gz"
  sha256 "d28bf9d02f9477bf3339e750287d32ecbeaa2d1398411624074a4d4498e9693a"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "519f7a0886d05e415ad4edf35171f12b8d7d0e1a5daa4f6e9137fea4ec4e6bba" => :high_sierra
    sha256 "d7b8d49792965389085593dac9d720e21a035a4a5029b4dbfc3c51b055aaca32" => :sierra
    sha256 "9d68642af97da6a135f23fb3ee63eff9bca19d4f041e5590eef6498af580fb2b" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/segmentio/chamber"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/chamber" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"chamber",
                   "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
