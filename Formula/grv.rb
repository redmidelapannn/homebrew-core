class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.3.2/grv-0.3.2-src.tar.gz"
  sha256 "988788cce5c581531c26df9048e4187440c5ebc9811afd371d565436dfb65d57"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "87f2367fa5c59833d693b15906172c3842121b473895a5c4b35f45661653f44b" => :catalina
    sha256 "be0b717a00932304aa1cfcde1440b904e51f130ce4ef08e3cd31a89afc5caff3" => :mojave
    sha256 "2df63f4c7cb4f4ec76fffe406f6343e3361ac7fbedfec2f8c8d314cfe6d90aac" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/rgburke/grv"
    path.install buildpath.children

    cd path do
      system "make", "build-only"
      bin.install "grv"
      prefix.install_metafiles
    end
  end

  test do
    ENV["TERM"] = "xterm"

    system "git", "init"
    system "git", "config", "user.email", '"test@example.com"'
    system "git", "config", "user.name", '"Test"'
    system "git", "commit", "--allow-empty", "-m", "test"
    pipe_output("#{bin}/grv -logLevel DEBUG", "'<grv-exit>'", 0)

    assert_predicate testpath/"grv.log", :exist?
    assert_match "Loaded HEAD", File.read(testpath/"grv.log")
  end
end
