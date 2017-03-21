class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  homepage "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  url "https://web.archive.org/web/20150915000000/www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz"
  version "4.51"
  sha256 "e1cd2e27109fbdbc6d435f2c3a99c8a6ef2898941f5d2f7bacf0c1ad70158bcf"

  bottle do
    rebuild 2
    sha256 "8fac24c53fa61f1c1f1c717a9b3ce6efa7c3ced459fdbe7796a07a13a62dc570" => :sierra
    sha256 "aa6fe73c876dd8a42cc9faf009a3769e223a870d55c63eb28e169b99eac62ef0" => :el_capitan
    sha256 "cb0d12fcf6f4d4f0da5fe5fa8ee5f9ef5afd5d67c6adfe473aa3aa4bdb8eb368" => :yosemite
  end

  def install
    # zcat doesn't handle gzip'd data on OSX.
    # Reported upstream to nrt@ff.iij4u.or.jp
    inreplace "src/stream.c", 'gz_filter = "zcat"', 'gz_filter = "gzcat"'

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib+"lv").install "lv.hlp"
  end
end
