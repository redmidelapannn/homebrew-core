class Polyglot < Formula
  desc "Protocol adapter to run UCI engines under XBoard"
  homepage "https://www.chessprogramming.org/PolyGlot"
  url "http://hgm.nubati.net/releases/polyglot-2.0.4.tar.gz"
  sha256 "c11647d1e1cb4ad5aca3d80ef425b16b499aaa453458054c3aa6bec9cac65fc1"
  head "http://hgm.nubati.net/git/polyglot.git", :branch => "learn"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9735ebd153638df9a47e1b3f6300f562dff0ac9db3ba0faa85a4ef152c6e8900" => :mojave
    sha256 "3ef1f75ec21e9f80fce13b11959a4216221fb527291163108d7a160c9e344e64" => :high_sierra
    sha256 "a66edf04ec7e0d61468c6fa51dbae8000de72db8ed842488c2f92e5de7538b77" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /^PolyGlot \d\.\d\.[0-9a-z]+ by Fabien Letouzey/, shell_output("#{bin}/polyglot --help")
  end
end
