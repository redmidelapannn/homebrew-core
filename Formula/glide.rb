class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.13.2.tar.gz"
  sha256 "0886851af2437b161d47b279a32bef426577e7bec3f5acdadebe34549aae8270"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8d32d75cd6719bdcb4d7a00f3128935b06fdeda1ba1eec6cdfbe1e2b285957eb" => :mojave
    sha256 "de16e0ce83205bf22987d8bb040c22e050db00e8c4f31b2354e395c9fc930074" => :high_sierra
    sha256 "7f1500c002a50fd4fe5639e6a00b948847f05e1274c9e926c34c3c15fa4703b7" => :sierra
    sha256 "b20e6e4df389ab498279ea283347a99db7e62091bbe85302c2a6692aec73c783" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    glidepath = buildpath/"src/github.com/Masterminds/glide"
    glidepath.install buildpath.children

    cd glidepath do
      system "go", "build", "-o", "glide", "-ldflags", "-X main.version=#{version}"
      bin.install "glide"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glide --version")
    system bin/"glide", "create", "--non-interactive", "--skip-import"
    assert_predicate testpath/"glide.yaml", :exist?
  end
end
