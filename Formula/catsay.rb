class Catsay < Formula
  desc "Cowsay for cat lovers"
  homepage "https://github.com/muhammadmuzzammil1998/catsay"
  url "https://github.com/muhammadmuzzammil1998/catsay/archive/v1.0.tar.gz"
  version "1.0"
  sha256 "3b31056aa635b7209df84c900af2800292f9626d56c74bfc61f260708e7a0ebd"

  bottle do
    cellar :any_skip_relocation
    sha256 "01c36f9177fa205e8c027950d6b4367e40e54d3664a1255a4cc68a04908cb5d7" => :mojave
    sha256 "d1f2e6658c24074cd04fb8fae1db54b0e54fdb2c543288dcdbf27bad9806bd9b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on :macos => :high_sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/muhammadmuzzammil1998/catsay").install buildpath.children
    cd "src/github.com/muhammadmuzzammil1998/catsay" do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/catsay", "app.go"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cowsay", "-help"
  end
end
