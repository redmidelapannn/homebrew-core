class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "https://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.7.28.tar.gz"
  sha256 "5caa2c769204f506e24ea4986a45abe23f71d14f0fe968314f20065f342ffdba"
  head "https://github.com/htacg/tidy-html5.git", :branch => "next"

  bottle do
    cellar :any
    sha256 "382966470a811a289346d9c61472b774476dd33dbf976988b161f988505a2182" => :mojave
    sha256 "70d067b98f8793aa0b147c380ec22a54f16f2637edd1f2f1431e704a3cd545b4" => :high_sierra
    sha256 "0f9a849422eac4d62f399fe6a6daa039b3a1de848daa9e2333e5aa29f70a984e" => :sierra
  end

  depends_on "cmake" => :build

  def install
    cd "build/cmake"
    system "cmake", "../..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    output = pipe_output(bin/"tidy -q", "<!doctype html><title></title>")
    assert_match /^<!DOCTYPE html>/, output
    assert_match /HTML Tidy for HTML5/, output
  end
end
