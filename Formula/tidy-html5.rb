class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "http://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.4.0.tar.gz"
  sha256 "a2d754b7349982e33f12d798780316c047a3b264240dc6bbd4641542e57a0b7a"
  head "https://github.com/htacg/tidy-html5.git", :branch => "next"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f4c18ae46bc14850268812eefc03e254c8504fd57991adf4383ffba9ef20dcc5" => :sierra
    sha256 "bf9b76a09b3076031512167fadb4921f38a26ad66ae78da215685a5e233e66a5" => :el_capitan
    sha256 "19523faadb2c2f40185349da167cc8c05936555fa6d1f54998aed3d63da0db2a" => :yosemite
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
