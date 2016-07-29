class AwsVault < Formula
  desc "securely stores and accesses AWS credentials in dev environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v3.3.0.tar.gz"
  sha256 "2eb7ad97de31d55d61c87b26c7f361aa49f3386ee63796930373a57ef53053ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b97d5175e7ac53c417ac8b2a6820877e090b7ee49580af29d8fb2523d9f0b87" => :el_capitan
    sha256 "4368026efa1c15505daa22db2aaf3ef0aa2afc2a0b8928b4a0e104c1f6c64589" => :yosemite
    sha256 "a13f12317b98c19a6d707c4cc27b2be02385644a55e91abb614ccae6f7cc489b" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"

    srcpath = buildpath/"src/github.com/99designs/aws-vault"
    srcpath.install Dir["*"]

    cd srcpath do
      system "go", "build"
      bin.install "aws-vault"
    end
  end

  test do
    system "#{bin}/aws-vault",  "--version"
  end
end
