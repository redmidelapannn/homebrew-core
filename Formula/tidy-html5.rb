class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.2.0.tar.gz"
  sha256 "80533415acf11ac55f24b874ab39448e390ffec3c2b93df4b857d15602fc7c4d"
  head "https://github.com/htacg/tidy-html5.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "061724e5467b889882ee819a0f4114c57e205a9e4851b31d41c750b87c410110" => :sierra
    sha256 "e1407029e4376986a1d63f7139656ff6dd01f1a34aa6094a3f6369584f7a8ad9" => :el_capitan
    sha256 "6f47d5a0c687abb168abe7634f6667daccd9ae01eee93a089744f0690c6c1862" => :yosemite
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
