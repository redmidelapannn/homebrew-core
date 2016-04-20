class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  homepage "https://web.archive.org/web/20160310122517/http://www.ff.iij4u.or.jp/~nrt/lv/"
  url "https://web.archive.org/web/20150915000000/http://www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz"
  version "4.51"
  sha256 "e1cd2e27109fbdbc6d435f2c3a99c8a6ef2898941f5d2f7bacf0c1ad70158bcf"

  bottle do
    revision 2
    sha256 "49ad4ebf6830c1ef3f6899486e711f99bc293d422317f8851f174cf18de2a98f" => :el_capitan
    sha256 "f31281558dc9da38402a86b2b3c03efb10ab471561bf72dd556c3cd8df23ba14" => :yosemite
    sha256 "eea0df5f3d2717211e0fe5fa4b31bc47be8bc73b7f5d83766ae394ec32a2e454" => :mavericks
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
