class Cmockery < Formula
  desc "Unit testing and mocking library for C"
  homepage "https://github.com/google/cmockery"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cmockery/cmockery-0.1.2.tar.gz"
  sha256 "b9e04bfbeb45ceee9b6107aa5db671c53683a992082ed2828295e83dc84a8486"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4f7c8ab32069e43bbfaf8b13bb1a1ad4791c767ec30864800754109738adad5f" => :catalina
    sha256 "539bb1185ccaa8737d4cef637411d11e57e2f80ba62c21da653376fcc13b20e2" => :mojave
    sha256 "16721a54ef9664ea15cd89a0e9ea258bd445637fcf90480c0f40a0ba40fe8b14" => :high_sierra
  end

  # This patch will be integrated upstream in 0.1.3, this is due to malloc.h being already in stdlib on OSX
  # It is safe to remove it on the next version
  # More info on https://code.google.com/p/cmockery/issues/detail?id=3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cmockery/0.1.2.patch"
    sha256 "4e1ba6ac1ee11350b7608b1ecd777c6b491d952538bc1b92d4ed407669ec712d"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
