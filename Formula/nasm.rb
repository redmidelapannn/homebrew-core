class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.xz"
  sha256 "4c866b60c0b1c4ebc715205d007b4640ff4e36af637c9a7deb87b2900e544321"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0339cefa0ddbd24e40ad84d5ae9d2345e6a61a27097666a4ac166897d40c0a31" => :sierra
    sha256 "87db22123e0bd8217190a211fc1babb24cce3bd2295deabcd8a6c01efcfcae22" => :el_capitan
    sha256 "7523c9b9b6adcad86a168c8de4f7a4e09de82d34df5384992bcdc5f5f884cd93" => :yosemite
  end

  head do
    url "git://repo.or.cz/nasm.git"
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "install", "install_rdf"
  end

  test do
    (testpath/"foo.s").write <<-EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
