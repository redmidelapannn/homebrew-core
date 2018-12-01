class Jshon < Formula
  desc "Parse, read, and create JSON from the shell"
  homepage "http://kmkeen.com/jshon/"
  url "https://github.com/keenerd/jshon/archive/20131105.tar.gz"
  sha256 "28420f6f02c6b762732898692cc0b0795cfe1a59fbfb24e67b80f332cf6d4fa2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f74dc38738da14652d1b910dbc8e5db037d5ff055d04a8e57998e69ebd45af3e" => :mojave
    sha256 "43298b131a96a8bf1ee90dfe59810341c7a8c68b3cf626f77a1270935d5f8fa3" => :high_sierra
    sha256 "47a4b97a9386631b917114f259354387604e1930c48867c2931af4373fe0e69f" => :sierra
  end

  depends_on "jansson"

  def install
    system "make"
    bin.install "jshon"
    man1.install "jshon.1"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"a":1,"b":2}
    EOS

    assert_equal "2", pipe_output("#{bin}/jshon -l < test.json").strip
  end
end
