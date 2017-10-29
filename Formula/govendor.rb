class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file"
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.9.tar.gz"
  sha256 "d303abf194838792234a1451c3a1e87885d1b2cd21774867b592c1f7db00551e"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1be8df79ea4d87c83d468e90983474c60833f72363de2fd3898abddd2b434a1d" => :high_sierra
    sha256 "216faada10b035483671f7fad5d834a4ca2c0f6c95f6d30eaba42d09a235309f" => :sierra
    sha256 "da33da746c5de0be40a6b46da4d83a6658a2f65cb8a52f92c5846284ed5ea86d" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    (buildpath/"src/github.com/kardianos/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/kardianos/govendor"
    system "go", "build", "-o", bin/"govendor"
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `govendor` bails without `.realpath` as it expects $GOPATH to be "real" path.
    ENV["GOPATH"] = testpath.realpath
    commit = "89d9e62992539701a49a19c52ebb33e84cbbe80f"
    (testpath/"src/github.com/project/testing").mkpath

    cd "src/github.com/project/testing" do
      system bin/"govendor", "init"
      assert_predicate Pathname.pwd/"vendor", :exist?, "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
