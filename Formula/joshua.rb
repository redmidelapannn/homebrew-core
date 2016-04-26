class Joshua < Formula
  desc "Statistical machine translation decoder."
  homepage "https://joshua.incubator.apache.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  head "https://git-wip-us.apache.org/repos/asf/incubator-joshua.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "7a6fae670cbfefee9c85e2ddec2c2e9687d5bff9237abb5364ac50606f58aab3" => :el_capitan
    sha256 "72a3c77f0c2da655506475c0c722e14b2722a80dcf5d9964aed6508212b17c57" => :yosemite
    sha256 "497bb1104a8b6d5ac46bc74f6d9097e3ffa2bae477a8f4722475a989537890fe" => :mavericks
  end

  option "with-es-en-phrase-pack", "Build with Spanish–English phrase-based model [1.9 GB]."
  option "with-ar-en-phrase-pack", "Build with Arabic–English phrase-based model [2.1 GB]."
  option "with-zh-en-hiero-pack", "Build with Chinese->English hiero-based model [2.4 GB]."

  depends_on :java
  depends_on "ant" => :build
  depends_on "boost" => :build
  depends_on "md5sha1sum" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "es-en-phrase-pack" do
    url "https://cs.jhu.edu/~post/language-packs/language-pack-es-en-phrase-2015-03-06.tgz"
    sha256 "213e05bbdcfbfa05b31e263c31f10a0315695fee26c2f37b0a78fb918bad9b5d"
  end

  resource "ar-en-phrase-pack" do
    url "https://cs.jhu.edu/~post/language-packs/language-pack-ar-en-phrase-2015-03-18.tgz"
    sha256 "2b6665b58b11e4c25d48191d3d5b62b7c591851a9767b14f9ccebf1951fddf90"
  end

  resource "zh-en-hiero-pack" do
    url "https://cs.jhu.edu/~post/language-packs/zh-en-hiero-2016-01-13.tgz"
    sha256 "ded27fe639d019c91cfefce513abb762ad41483962b957474573e2042c786d46"
  end

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"
    head do
      system "ant"
    end
    if build.with? "es-en-phrase-pack"
      resource("es-en-phrase-pack").stage do
        (libexec/"language-pack-es-en-phrase-2015-03-06").install Dir["*"]
      end
    end
    if build.with? "ar-en-phrase-pack"
      resource("ar-en-phrase-pack").stage do
        (libexec/"language-pack-ar-en-phrase-2015-03-18").install Dir["*"]
      end
    end
    if build.with? "zh-en-hiero-pack"
      resource("zh-en-hiero-pack").stage do
        (libexec/"zh-en-hiero-pack-2016-01").install Dir["*"]
      end
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
