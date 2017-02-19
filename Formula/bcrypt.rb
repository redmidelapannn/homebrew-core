class Bcrypt < Formula
  desc "Cross platform file encryption utility using blowfish"
  homepage "https://bcrypt.sourceforge.io"
  url "http://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz"
  sha256 "b9c1a7c0996a305465135b90123b0c63adbb5fa7c47a24b3f347deb2696d417d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "12dd24a66e50aad60394625d7e3416e9a5b3a0824be141cb46c2f537b918ebf8" => :sierra
    sha256 "171d7805727991734074f7e1a84b3a9d23dbe42551c6b8bfbd6a89f37602c1f7" => :el_capitan
    sha256 "18cf9e56a78ade3452f17a36d837400f94acc3e86343e42b41725bc1b14a0b62" => :yosemite
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    pipe_output("#{bin}/bcrypt -r test.txt", "12345678\n12345678\n")
    mv "test.txt.bfe", "test.out.txt.bfe"
    pipe_output("#{bin}/bcrypt -r test.out.txt.bfe", "12345678\n")
    assert_equal File.read("test.txt"), File.read("test.out.txt")
  end
end
