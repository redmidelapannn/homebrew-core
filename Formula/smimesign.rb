class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.0.13.tar.gz"
  sha256 "baf3e1c0a64ca1d49be8a4e99640679ba2b2870e907e88be1e9c7f1566d0f206"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d96cb2ffb534ff2649a615978c65142d94a8a3a9b8cdbc31e989572b28520502" => :mojave
    sha256 "c61e3a969e8d11eb7bde0f4a1910a7fa099e1c60fec746fcd3c5e66771463bc5" => :high_sierra
    sha256 "594e9cef0a792178bd3f0d999e04dc633ad0484e48b9ba36ca136572f3ad6f6f" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children

    cd "src/github.com/github/smimesign" do
      system "go", "build", "-o", bin/"smimesign", "-ldflags", "-X main.versionString=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity", shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
