class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.1.tar.gz"
  sha256 "1a0fa95d6be5958edca31a80de3594a563de6f7d09213418db895dda6724c271"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1f855609242ff35ecbf1f73656e499c47ed6c1ba7f123d457f14917a0086f94f" => :mojave
    sha256 "9da3903c4fa04ad18c2c6b59c9701477f8d7e8a0a4a5aa00b94440fc023fc94c" => :high_sierra
    sha256 "9da3903c4fa04ad18c2c6b59c9701477f8d7e8a0a4a5aa00b94440fc023fc94c" => :sierra
  end

  depends_on "chruby"
  depends_on "fish"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /chruby-fish/, shell_output("fish -c '. #{share}/chruby/chruby.fish; chruby --version'")
  end
end
