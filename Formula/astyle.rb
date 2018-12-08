class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.1/astyle_3.1_macos.tar.gz"
  sha256 "c4eebbe082eb2cb98f90aafcce3da2daeb774dd092e4cf8b728102fded8d1dcf"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "46f7d746814922b3ab5c51cac8e81aa267f6e5fb9f05342f89cd02a5fec0eb1e" => :mojave
    sha256 "d4f573b12847a36fcece81ed0522d96c6ff732373c06295daab08ed446b23776" => :high_sierra
    sha256 "76b0cc35cac995cd9b909cea1f6931acb664d5a20a74eb61607754119da882e0" => :sierra
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
