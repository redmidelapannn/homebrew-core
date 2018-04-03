class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/nasm-2.13.03.tar.xz"
  sha256 "812ecfb0dcbc5bd409aaa8f61c7de94c5b8752a7b00c632883d15b2ed6452573"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "22f90d5ae9c347bdbf77c171ffc35474f053d6245147cada6405ae72050aceee" => :high_sierra
    sha256 "b64a30af578bf4f1dd07c2cefbb7dfbadb2442069ebd904628b7d262c2408a24" => :sierra
    sha256 "685d856e3268eb9e9312539840897085dfca516a7e83b93a9748a24349e0b775" => :el_capitan
  end

  head do
    url "http://repo.or.cz/nasm.git"
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "rdf"
    system "make", "install", "install_rdf"
  end

  test do
    (testpath/"foo.s").write <<~EOS
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
