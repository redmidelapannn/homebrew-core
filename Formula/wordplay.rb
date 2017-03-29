class Wordplay < Formula
  desc "Anagram generator"
  homepage "http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html"
  url "http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z"
  version "7.22"
  sha256 "9436a8c801144ab32e38b1e168130ef43e7494f4b4939fcd510c7c5bf7f4eb6d"

  bottle do
    rebuild 1
    sha256 "07824a81c9da37796bfea374bdf54349bc4481628438eaf9d138c774a24ab74b" => :sierra
    sha256 "9e14d6411cde57578b760f819f1d2aff40e5984b8174d002c05ab5e70089b8fc" => :el_capitan
    sha256 "4794a4ed8440ec2037972a239aea833d3566a2b49a3f9e3525bef5d5b7887a89" => :yosemite
  end

  # Fixes compiler warnings on Darwin, via MacPorts.
  # Point to words file in share.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5de9072/wordplay/patch-wordplay.c"
    sha256 "45d356c4908e0c69b9a7ac666c85f3de46a8a83aee028c8567eeea74d364ff89"
  end

  def install
    inreplace "wordplay.c", "@PREFIX@", prefix
    system "make", "CC=#{ENV.cc}"
    bin.install "wordplay"
    pkgshare.install "words721.txt"
  end
end
