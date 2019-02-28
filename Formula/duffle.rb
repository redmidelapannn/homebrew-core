class Duffle < Formula
  desc "Command-line to install and manage CNAB bundles"
  homepage "https://duffle.sh"
  url "https://github.com/deislabs/duffle/archive/0.1.0-ralpha.5+englishrose.tar.gz"
  sha256 "81e31da0fddfdcff12d95a5711a2a6f0e343eecf523829b21063a3edef62a9d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ab6d9cdbe577308429ef481a57b8d6ece7fe984ed2e9931aa42f3be76fa8c32" => :mojave
    sha256 "ca864b5d1eeec708c4ee488ec30b31aae9c75bf1e3a35e23ab0e0cbe44b1031b" => :high_sierra
    sha256 "e214cb40d280fddc529e0ceb80a5cfaf74248ff14dbbfe369ee7952f80e59b57" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/deislabs/duffle").install buildpath.children

    cd "src/github.com/deislabs/duffle" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "./bin/duffle"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/duffle", "init"
  end
end
