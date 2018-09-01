class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v951src.tgz"
  version "9.5.1"
  sha256 "062a680862b1c10c21789c0c7c7687c970a720186918d5ed1f7aad9fdc6fa9b9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "533327d46c6cc719c58215c43f4cdfcff083ce3b1f547a78cd5ddb04b713d88f" => :mojave
    sha256 "ee410f2185659e42d30f80c61eca34e04e1388b00c99aa61646cbeb115399023" => :high_sierra
    sha256 "c9007a6e839a999c163cf1c341215a32ae81c787c1b4045279fd79cf206773ff" => :sierra
    sha256 "1391a90e95a4eca3613603d90d5a86db829dc8f3401c26d434cfae8ac9a0a1b9" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "make", "Configure", "name=posix"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
