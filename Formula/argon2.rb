class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20190702.tar.gz"
  sha256 "daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6d98c54109a6112c93aba80fce6d0887dc48857f19c20fc2148a6c8ab20d2040" => :mojave
    sha256 "380745a931329cae040e8393914be12793681f340a097c25e66f019ca9c31ab0" => :high_sierra
    sha256 "bb0d7bb50657b843512aaef1dcdd00dfbfa856cc90a3e7538b30b19ce264bd13" => :sierra
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end
