class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20170823.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20170823.orig.tar.xz"
  version "0.1+git20170823"
  sha256 "aa10c17f703ef46a88f9772205d8f51285fd3567aa91931ee1a7a5abfff95b11"
  revision 2
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "54c136031fe609bd1d78b408f58aad4374ff415e69e4269f98becd28eb0e8e6d" => :high_sierra
    sha256 "2a8c1478c92a92606e47d9032a3dfaf1ab6b2f246ef2a718905925651f84977e" => :sierra
    sha256 "ad204f3be52cfa222dbb87932c67f927a3c601368dd6a99e21cbaac76c5851fc" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm@5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++", "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
