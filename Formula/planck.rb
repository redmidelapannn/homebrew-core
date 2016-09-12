class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.17.tar.gz"
  sha256 "f088acecc25412f901b512478d9fd5acf38c1ff0276f18d45f78ad9a5ce37596"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "16c387a191f904fac90b8fc9e10de2178bd2ef3f1191e207a41d8eacb37f774c" => :el_capitan
    sha256 "930720cc67077cd85cdffdbc8be4859d9b0d832995cec95d97cc1d1824972cbd" => :yosemite
    sha256 "0fe6241cd4317e4a8f2c7234afc39c7d43300fc8a9da30059c3085659c80c41f" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
