class Dunner < Formula
  desc "Task runner tool like Grunt but uses Docker images like CircleCI does"
  homepage "https://github.com/leopardslab/Dunner"
  url "https://github.com/leopardslab/Dunner/archive/v1.0.0.tar.gz"
  sha256 "78837210dc5e3a828f8286a81a2cc995e5f719d8bd00138c4257ee4a55b1d536"
  head "https://github.com/leopardslab/Dunner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6ba25ba6699e9fcd235537cfd1f0ad8758b9e80f59498d025e4116dc9756d41" => :mojave
    sha256 "78de8a80784a3128a5305ad5518dedbc8d4073ba33ecd6fa94ae578b8db40c92" => :high_sierra
    sha256 "0bac07b167328a859b3a73be8f5a114ce8a791f6ab3b673cd126125cb9a92a4e" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/leopardslab/Dunner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "dunner"

      bin.install "dunner"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/dunner version")
  end
end
