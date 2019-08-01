class Cuts < Formula
  desc "Unix 'cut' (and 'paste') on steroids: more flexible select columns from files"
  homepage "http://arielf.github.io/cuts/"
  url "https://github.com/arielf/cuts/archive/18c9c341f0f3679a6bc8b83b4a1f60f9208d780e.zip"
  head "https://github.com/arielf/cuts.git"
  version "20180815"
  sha256 "fda9850588f8090895fd6e68085d6481c8c51ce2eacd5c6dc9736dddf2f488bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "0869413c610d5ae8f46cfe7b9683267ffb108229b680ae43232006fa1b642a39" => :mojave
    sha256 "0869413c610d5ae8f46cfe7b9683267ffb108229b680ae43232006fa1b642a39" => :high_sierra
    sha256 "b1420fe8fb25f0b1da4efc989da84fe9a714fc63e8f4901c129ded6080aadefc" => :sierra
  end

  def install
    bin.install "cuts"
  end

  test do
    assert_match "test", shell_output("echo \"0 test\" | #{bin}/cuts 1").chomp.strip
  end
end
