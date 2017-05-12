class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.6.tar.gz"
  sha256 "d368f4fb7d8a394f65730682dba6fddfe75b3c6119756799cdb3cd5e1ae78e0d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5eac7b95c2ff1ec425940f4259ad910df2871b4c90e0b3f2f9367738269ec78b" => :sierra
    sha256 "83c8d480820f97d0d67b1b91a9fac7283e5df4df8dba2172c2314aacbd66515d" => :el_capitan
    sha256 "c9d1bc127f0a1100bf9463f0a8d3e41e024965e9a94d700e12722ca22a3493dc" => :yosemite
  end

  head do
    url "https://github.com/vhelin/wla-dx.git"

    depends_on "cmake" => :build
  end

  def install
    if build.stable?
      %w[CFLAGS CXXFLAGS CPPFLAGS].each { |e| ENV.delete(e) }
      ENV.append_to_cflags "-c -O3 -ansi -pedantic -Wall"

      chmod 0755, "unix.sh"
      system "./unix.sh", ENV.make_jobs
      bin.install Dir["./binaries/*"]
    else
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test-gb-asm.s").write <<-EOS.undent
     .MEMORYMAP
      DEFAULTSLOT 1.01
      SLOT 0.001 $0000 $2000
      SLOT 1.2 STArT $2000 sIzE $6000
      .ENDME

      .ROMBANKMAP
      BANKSTOTAL 2
      BANKSIZE $2000
      BANKS 1
      BANKSIZE $6000
      BANKS 1
      .ENDRO

      .BANK 1 SLOT 1

      .ORGA $2000


      ld hl, sp+127
      ld hl, sp-128
      add sp, -128
      add sp, 127
      adc 200
      jr -128
      jr 127
      jr nc, 127
    EOS
    system bin/"wla-gb", "-o", testpath/"test-gb-asm.s"
  end
end
