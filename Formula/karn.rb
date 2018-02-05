class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.4.tar.gz"
  sha256 "68d244558ef62cf1da2b87927a0a2fbf907247cdd770fc8c84bf72057195a6cb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "921c191ddc25c1aa2368f6341899d87ae79bb0aac5b82bfed762e8bfbc8cffaf" => :high_sierra
    sha256 "aff19e36e071f9c0fc78a1dc75ce4fecb01980380813b04c8c2e1595ebbc7337" => :sierra
    sha256 "e855c58f4a751057d7df920da158b7c59632afd9e99ff3d45426fd30d6a91f61" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prydonius/karn").install buildpath.children

    cd "src/github.com/prydonius/karn" do
      system "go", "build", "-o", bin/"karn", "./cmd/karn/karn.go"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/".karn.yml").write <<~EOS
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    EOS
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "#{bin}/karn", "update"
  end
end
