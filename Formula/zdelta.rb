class Zdelta < Formula
  desc "Lossless delta compression library"
  homepage "https://web.archive.org/web/20150804051750/cis.poly.edu/zdelta/"
  url "https://web.archive.org/web/20150804051752/cis.poly.edu/zdelta/downloads/zdelta-2.1.tar.gz"
  sha256 "03e6beb2e1235f2091f0146d7f41dd535aefb6078a48912d7d11973d5306de4c"
  head "https://github.com/snej/zdelta.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d24ae123b06cc0f45bbf78a530a6d1aa455e1e463304cffe160701cd3562380a" => :mojave
    sha256 "232b61a14293e02a177d50267d4a460d68bf9da2030e87272ce868c1e4b17892" => :high_sierra
    sha256 "a90bf59e2b124d9ff3f5c352b846e5afcd7e6e5e38f7338f4f3f31784949e95e" => :sierra
  end

  def install
    system "make", "test", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "prefix=#{prefix}"
    bin.install "zdc", "zdu"
  end

  test do
    msg = "Hello this is Homebrew"
    (testpath/"ref").write "Hello I'm a ref file"

    compressed = pipe_output("#{bin}/zdc ref", msg, 0)

    assert_equal msg, pipe_output("#{bin}/zdu ref", compressed, 0)
  end
end
