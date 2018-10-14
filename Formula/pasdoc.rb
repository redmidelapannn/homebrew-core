class Pasdoc < Formula
  desc "Documentation tool for ObjectPascal (FP, Lazarus, Delphi) source code"
  homepage "https://github.com/pasdoc/pasdoc/wiki"
  url "https://github.com/pasdoc/pasdoc/archive/v0.15.0.tar.gz"
  sha256 "9863c56a199d12bfc22f2ff06d387831e01f052a59c5ad087717756d9193ed6d"
  head "https://github.com/pasdoc/pasdoc.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "1998776d0d9e1d341928d3f3f3812fe0eae4fbdbb12cf0171df89fd7d832e00d" => :mojave
    sha256 "b75b6e98dad5b23fa0ee6d56a26f4e3f3a7121a613155e47cfd529628433b183" => :high_sierra
    sha256 "57ecac32f9da8a978e9afe6c9ad54f9e811a7f0de02b01ec8c89c1245c5b68fb" => :sierra
  end

  depends_on "fpc" => :build

  def install
    system "make", "build-fpc-default"
    bin.install Dir["bin/*"]
  end

  test do
    hello = <<~EOS
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/pasdoc", "--format=html", "hello.pas"
    assert_path_exist(testpath/"Hello.html")
  end
end
