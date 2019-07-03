class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20190702.tar.gz"
  sha256 "daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "db111b3e0aefcec6521cab6ee67534fc25696ac5042edc8a1057b5754473ea24" => :mojave
    sha256 "1789a8e5e4adf148fa49db9cb24017a1d5c3bdb676d92d959d6c47a8f923153d" => :high_sierra
    sha256 "a91df5d368da7f0972852dd0899358c983e468b8def4cac4be3d88061a6dde11" => :sierra
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
