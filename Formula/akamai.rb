class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.0.2.tar.gz"
  sha256 "d3855ddbaf11cac3f0f164937faa1153ea9d1ab41175989311eab674d9b4a635"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7b6bb877c70c0dc5d7c066dd7a114b0ee40664906aa4a055ccad7cf7a569397c" => :high_sierra
    sha256 "cffe00742892299a3a9aa9889475a96f7bf8142f309af88df77361e5a007f0e9" => :sierra
    sha256 "dcf883dcad2209b8d9136a78b02540f663a5c1c088f936f974e98b593430f515" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
