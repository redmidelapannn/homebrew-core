class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/archive/v1.0.2.tar.gz"
  sha256 "5bb4de182683797d44cd8921a26d8732e7f29f2eb382bea47a57372c44ccaaab"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce68535684b4d599275d2afd9230112b6dd6dd0642064bd6ab90d5a24f7a12ae" => :high_sierra
    sha256 "7592c7de2b29100457e1dedb795b95b13d31040fe8fae0a797d2a8a6f4a9a3b4" => :sierra
    sha256 "8b5c4a880ee262a44cc9fb3ac43cd41d67a096c77bd14dbd249ea009ddeaed56" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/yinheli/sshw").install buildpath.children

    cd "src/github.com/yinheli/sshw" do
      system "make", "sshw"
      bin.install "release/sshw"
    end
  end

  test do
    system "#{bin}/sshw", "-version"
  end
end
