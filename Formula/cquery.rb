class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180718",
                                                      :revision => "b523aa928acf8ffb3de6b22c79db7366a9672489"
  head "https://github.com/cquery-project/cquery.git"

  bottle do
    sha256 "ae74b1b6e3c2153064287e586b7ed13dfa6962ae293550fe3c0963b781a838bc" => :high_sierra
    sha256 "2478f830e485f17c5ac6675fad5fb76fad5c0e3e472afa9aa83a0e586f090a43" => :sierra
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
