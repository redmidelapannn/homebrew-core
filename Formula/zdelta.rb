class Zdelta < Formula
  desc "Lossless delta compression library"
  homepage "https://web.archive.org/web/20150804051750/cis.poly.edu/zdelta/"
  url "https://web.archive.org/web/20150804051752/cis.poly.edu/zdelta/downloads/zdelta-2.1.tar.gz"
  sha256 "03e6beb2e1235f2091f0146d7f41dd535aefb6078a48912d7d11973d5306de4c"
  head "https://github.com/snej/zdelta.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "23c5cd4a759f1b2bd46f1ece1b18b9c6024e35efd5b2e1bf31518212726b25fe" => :catalina
    sha256 "83d4896d4d54a1213f06c4acbf27d011903d046d9c0a9ccdeddd893b7a03ad81" => :mojave
    sha256 "d5a4379f2bb33a00c1b5f1d906aeca30a2f57bb330760380069a6413ab0086b4" => :high_sierra
  end

  def install
    system "make"
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
