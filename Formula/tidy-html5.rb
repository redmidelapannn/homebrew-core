class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "https://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.6.0.tar.gz"
  sha256 "08a63bba3d9e7618d1570b4ecd6a7daa83c8e18a41c82455b6308bc11fe34958"
  head "https://github.com/htacg/tidy-html5.git", :branch => "next"

  bottle do
    cellar :any
    rebuild 1
    sha256 "71c3dc160ace4572d6bfbd04c2f6e7dfb299cf49265268d2f5ba0bdcad4033a9" => :high_sierra
    sha256 "5c458ba424ff8cf8d9e6d0ecf6fffc21089cfb108aae652e9edeedcdc0f77639" => :sierra
    sha256 "8dc20aae86d7e0ec2b264530d465a9ea18851244da1269c77cd5112c6c2884ed" => :el_capitan
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
