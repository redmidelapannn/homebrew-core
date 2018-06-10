class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.1.tar.gz"
  sha256 "785f206030b71f0117c975226f490aa370ee5eda36597010677794b539151743"

  bottle do
    rebuild 1
    sha256 "8c85baa9b8c7e30ff10a26fcfe6a53d5178cb64f5595ec24e30587a2bd77356c" => :high_sierra
    sha256 "bfe3619105deff4498596af72c8d8c90e599d3d63bc4603f83d3b0d8f593f7ef" => :sierra
    sha256 "8e7c81af1e5dc6ab96f65c95fde5bb39b9d54df3b863db742cee923f4e5e1fcc" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.txt").write("")
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
