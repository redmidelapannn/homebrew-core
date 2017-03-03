class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.8.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.8.1.orig.tar.gz"
  sha256 "e49c71d7ddcd312dcc819c3be203abd3d09d286500ee777cde434c7881962b39"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "802d65684ceb5258ff325d2cdfc4344fb8fd9578a7fc7f57d49a780aaa95a72d" => :sierra
    sha256 "802d65684ceb5258ff325d2cdfc4344fb8fd9578a7fc7f57d49a780aaa95a72d" => :el_capitan
    sha256 "802d65684ceb5258ff325d2cdfc4344fb8fd9578a7fc7f57d49a780aaa95a72d" => :yosemite
  end

  depends_on "cd-discid"
  depends_on "cdrtools"
  depends_on "id3v2"
  depends_on "mkcue"
  depends_on "md5sha1sum"
  depends_on "flac" => :optional
  depends_on "lame" => :optional
  depends_on "vorbis-tools" => :optional
  depends_on "glyr" => :optional

  def install
    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abcde -v")
  end
end
