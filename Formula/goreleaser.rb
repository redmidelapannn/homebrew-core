class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.118.1",
      :revision => "eb1a122199bc2917ffa21bb8a41f38485a14824e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "90c29b953fe53314a78a28d62100729a2ff347c96b4f647b9a233ba3bdbd4308" => :mojave
    sha256 "10e3036897de5e57ea10a7d925c9019ffdabee1f43b3c3272f5fb3d04cc7d5e1" => :high_sierra
    sha256 "1883cb3afa4c2a54937d4c3a9553d8b9fd3f2c6f688c65519fdbd88c7c93a1f6" => :sierra
  end

  depends_on "go" => :build

  # Should be removed in the next release
  patch do
    url "https://github.com/goreleaser/goreleaser/pull/1154.patch?full_index=1"
    sha256 "a68a0c56938136b419e13138a91e008d30be90195e2fcef4b9337637b50f56bf"
  end

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/goreleaser/goreleaser"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags",
                   "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
