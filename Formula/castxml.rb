class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  revision 1
  head "https://github.com/CastXML/castxml.git"

  stable do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20160706.orig.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20160706.orig.tar.xz"
    version "0.1+git20160706"
    sha256 "28e7df5f9cc4de6222339d135a7b1583ae0c20aa0d18e47fa202939b81a7dada"

    # changes from upstream to fix compilation with LLVM 3.9
    patch do
      url "https://github.com/CastXML/CastXML/commit/e1ee6852c79eddafa2ce1f134c097decd27aaa69.patch"
      sha256 "d47f4566bda6f8592c120052aeec404de371dc27b0ef15d5c337c34f87976901"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "bd846e79fc85c4d1b87653734bf7b171afba6ccedc8d2f5ccb53ab205cf0a1ff" => :sierra
    sha256 "8172a02590d9f5fd2c707564601a16afe4b4ee673ee1a6fc744763abb83875d3" => :el_capitan
    sha256 "407db1d3ff929c18cea7d93f7fbd930a09d624d50af868e64dfa308262a8216c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++", "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
