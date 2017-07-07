class Qtrn < Formula
  desc "Cli tool to streamline financial markets data analysis"
  homepage "https://github.com/FlashBoys/qtrn"
  url "https://github.com/FlashBoys/qtrn/archive/v0.3.tar.gz"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ec371f91f41108af466fe717b7bc2367f89287e6daa2799c3d3270761fa5a3b" => :sierra
    sha256 "6b22912363133edaf728f90c944dc2cfc60db72790cc63de75da31f3f644f956" => :el_capitan
    sha256 "9f906593af95683376526f29a502854e23a984e93e7c4249dc7326d3327508d9" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/FlashBoys/qtrn"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", "build/qtrn",
        "-ldflags",
        "'-X=github.com/FlashBoys/qtrn/version.Version=#{version}'"
      bin.install "build/qtrn"
    end
  end

  test do
    system bin/"qtrn", "-v"
  end
end
