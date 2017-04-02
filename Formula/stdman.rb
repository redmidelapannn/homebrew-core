class Stdman < Formula
  desc "Formatted C++11/14/17 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman.git",
    :revision => "61d5fbd2c831f82b29ffd247ee73539b456ba0d6"
  version "2017-02-14"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46a632dcc841afbc603ed0397a4cc80da5f132f98b46c720f7d4ec78f494202a" => :sierra
    sha256 "52192480be1256fb1abea025459b8037fe3c55e06decc898c0fcd0a811914ee2" => :el_capitan
    sha256 "f0813f8f592866ddad06cea39563a9da8c0a1769403a8dec1da5f7e1e524f3d4" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
