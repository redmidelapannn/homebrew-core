class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 1

  bottle do
    revision 1
    sha256 "47375bba259a8ab91c8424703865162439ea9353dbaeb9bf5525d6b659cc500d" => :el_capitan
    sha256 "773d72af264ede924245a97dfdc42bbe1afde439714f2a923f48e9d9e8eabf8f" => :yosemite
    sha256 "99c07860492c714c92530a36e18b9e971d3020d31c204f2bca6f797245cf6081" => :mavericks
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
