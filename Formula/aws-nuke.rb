class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke/archive/v2.8.0.tar.gz"
  sha256 "3539303b864e983e7b8b3e43f83ae9a4900b8361170aac0cd123132f16d4acc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a68adb00c068e485f61547d41db8391580aa98e7872689d1f91612cc5d4f4e8" => :mojave
    sha256 "4ce564ba38c1e7e570c93f0651a05633044eb06b902865d10fb3a7df1e16a784" => :high_sierra
    sha256 "2d0c5d8c65ec3ae9e20a99ac5b61e2204748bedf458241f1678f1df141fb0093" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    srcpath = buildpath/"src/github.com/rebuy-de/aws-nuke"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build"
      bin.install "aws-nuke--darwin-amd64" => "aws-nuke"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "resource-types", shell_output("#{bin}/aws-nuke --help")
  end
end
