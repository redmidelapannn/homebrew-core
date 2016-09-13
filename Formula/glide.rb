class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.12.2.tar.gz"
  sha256 "ebb20c81df87e4d230027e07d81d88ce8ef18400df62c82f7b766693acb3106e"

  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd5616010cb4d0e10cf87ca618febf4c8b7b09508222a8a79d7cce564daf3916" => :el_capitan
    sha256 "f65e4e8cfa3f7fa712ab54930b8decb6d8be797f40db123879bb40866a3cdbc1" => :yosemite
    sha256 "943b19f66498df20048c17b4ef1be5fc3cd8fbb86cc678251e2a67edc7384a35" => :mavericks
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
    assert File.exist?("glide.yaml")
  end
end
