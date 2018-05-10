class Joshua < Formula
  desc "Statistical machine translation decoder"
  homepage "https://joshua.incubator.apache.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  head "https://git-wip-us.apache.org/repos/asf/incubator-joshua.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "c9680f47d6a284277a027c1a18d764418aefe2fb9f28f61be9c223931d50fc1e" => :high_sierra
    sha256 "c9680f47d6a284277a027c1a18d764418aefe2fb9f28f61be9c223931d50fc1e" => :sierra
    sha256 "c9680f47d6a284277a027c1a18d764418aefe2fb9f28f61be9c223931d50fc1e" => :el_capitan
  end

  depends_on :java
  depends_on "ant" => :build
  depends_on "boost" => :build
  depends_on "md5sha1sum" => :build
  depends_on "python@2" => :build

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"
    head do
      system "ant"
    end
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    inreplace "#{bin}/joshua-decoder", "JOSHUA\=$(dirname $0)/..", "#JOSHUA\=$(dirname $0)/.."
    inreplace "#{bin}/decoder", "JOSHUA\=$(dirname $0)/..", "#JOSHUA\=$(dirname $0)/.."
  end

  test do
    assert_equal "test_OOV\n", pipe_output("#{libexec}/bin/joshua-decoder -v 0 -output-format %s -mark-oovs", "test")
  end
end
