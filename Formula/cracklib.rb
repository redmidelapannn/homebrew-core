class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-2.9.7.tar.gz"
  sha256 "8b6fd202f3f1d8fa395d3b7a5d821227cfd8bb4a9a584a7ae30cf62cea6287dd"

  bottle do
    cellar :any
    sha256 "ca47aca37fb610d044a31e91c19bb01272fb7ae79bf74f10966f5e8bdbce577c" => :mojave
    sha256 "0eda7a16ec9bf1d6e505f659578884c71ddd4f83f231e4de6deaed06b3f176bd" => :high_sierra
    sha256 "f02a502b0928a9358afe71a798921d13b23d0efbcb78754d3bdcedf3c4bf3098" => :sierra
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-words-2.9.7.gz"
    sha256 "7f0c45faf84a2494f15d1e2720394aca4a379163a70c4acad948186c0047d389"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match /password: it is based on a dictionary word/, pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
