class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.6.2/mlr-5.6.2.tar.gz"
  sha256 "29b69cf8d0051688aeba3f6998d9b69baea1c9d0a2c14fef56cdb6fa03110eab"

  bottle do
    cellar :any_skip_relocation
    sha256 "64fdfa5c022fa1c938279718bd74591de48d1a5845658720d1f042dd03840c02" => :high_sierra
    sha256 "530ab9b83891ec55d4847c4bcf02af1202443a86c4782ede1a6b908a8956a498" => :sierra
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
